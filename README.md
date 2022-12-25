# devbox

This repo creates my preferred development environment from declarative
configuration files.

This allows me to recreate my development environment across systems (e.g. if I
get a new laptop).

## Goals

I set the following goals to ensure long-term maintenance of this repo:

  - Idempotent: I can re-run the install at any time to enforce the correct
    state.
  - Seamless: When I make changes to my local dotfiles, those changes should be
    automatically saved and managed (if not automatic, very easily). I
    shouldn't have to copy my configs somewhere whenever I update them locally.
    I also don't want to manually manage symlinks because it's not scalable.
  - Test mode: the provision should be able to show me what it would do without
    doing it. If it has been a while since I've provisioned, I want to verify
    that the script won't overwrite important files. I should never have to
    provision without knowing exactly what is being changed.

These goals are achieved through [ chezmoi ](https://www.chezmoi.io/) and [
Saltstack ](https://saltproject.io/). Chezmoi is excellent for static dotfiles
and Salt meets these goals for packages. By combining the two, it provides a
complete solution.

# Provisioning

Clone the repo:

```
git clone https://github.com/rsutton1/dotfiles.git
```

There are two options for provisioning: inside a VM or directly on the host.

## VM

Install Vagrant: https://www.vagrantup.com/downloads

Then run:

```
cd dotfiles
vagrant up
vagrant ssh -- -A # ssh forwarding for pushing code changes
sudo salt-call state.apply # provision changes inside VM
```

## Host

Currently only works on Debian-based systems.

### Dependencies

Salt 3004.X: download for your platform here https://repo.saltproject.io/

Using [salt-bootstrap](https://github.com/saltstack/salt-bootstrap#install-using-curl):
```
sudo sh bootstrap-salt.sh -X stable 3004.2
```

### Commands

```
cd dotfiles/salt
./configure.sh # setup salt installation
sudo salt-call state.apply test=true # show what Salt would do
sudo salt-call state.apply # apply changes to your system
```

# Testing

Use kitchen-docker to test.

```
cd dotfiles/salt
sudo salt-call state.apply kitchen
source ~/.bashrc
rbenv local 2.6.10
bundle install
bundle exec kitchen converge
```
