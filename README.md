# dotfiles

This repo stores files and scripts to provision my preferred development
environment.

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

## Note

Currently only works on Debian-based systems. Tested with Salt 3004.

# Provisioning a new system

## Dotfiles

The following commands will install `chezmoi` and copy the dotfiles to your
system in the correct location.

```
$ sh -c "$(curl -fsLS chezmoi.io/get)" -- init rsutton1
$ chezmoi diff # see what chezmoi would do
$ chezmoi apply
```

## Packages

Let's install Salt and then use it to install the packages.

### Install Salt

If you're on Debian, you can use the provided script to install Salt into a
self-contained venv (my preference).

```
$ ~/salt/install_salt.sh
```

Otherwise, you can use [ salt-bootstrap
](https://github.com/saltstack/salt-bootstrap#install-using-curl), a convenient
cross-platform bash script to install Salt.

### Install packages

```
$ cd salt/
$ sudo salt-call state.sls packages test=true # show what Salt would do
$ sudo salt-call state.sls packages
```

# Reprovisioning

To reprovision we pull remote changes and verify they look correct before
installing them.

## Pull and view changes

```
$ cd ~/salt
$ chezmoi git pull -- --rebase && chezmoi diff
$ sudo salt-call state.sls packages test=true
```

## Apply

```
$ cd ~/salt
$ chezmoi apply
$ sudo salt-call state.sls packages
```

# Save changes

Once you've provisioned your system and made some local changes, here's how to
save them back into the repo.

```
$ chezmoi add ~/.some_dotfile
$ chezmoi add salt/files/packages.sls
$ chezmoi cd
$ git add dot_some_dotfile salt/files/packages.sls
$ git commit -m "changed some dotfile, changed packages"
$ git push
```
