packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  commit = true
}

build {
  name = "base"

  source "source.docker.ubuntu" {
    image = "ubuntu:focal"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /srv/salt/",
    ]
  }

  provisioner "file" {
    source      = "salt/files/pygit.sls"
    destination = "/srv/salt/pygit.sls"
  }

  provisioner "shell" {
    inline = [
      "mkdir /etc/apt/keyrings",
      "apt-get update",
      "apt-get install curl -y",
      "curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg",
      "echo \"deb [signed-by=/etc/apt/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/latest focal main\" | tee /etc/apt/sources.list.d/salt.list",
      "apt-get update",
      "apt-get install salt-minion -y",
    ]
  }

  provisioner "shell" {
    inline = [
      "salt-call --local state.apply pygit -l quiet # for gitfs",
    ]
  }

  post-processor "docker-tag" {
    repository = "rsutton1"
    tag        = ["ubuntu-salt"]
  }

}

build {

  name = "devbox-root"

  source "source.docker.ubuntu" {
    image = "rsutton1:ubuntu-salt"
    pull  = false
    changes = [
      "ONBUILD RUN date",
    ]
  }

  provisioner "file" {
    source      = "salt/files"
    destination = "/srv/salt/files"
  }

  provisioner "file" {
    source      = "salt/pillar"
    destination = "/srv/salt/pillar"
  }

  provisioner "file" {
    source      = "salt/system"
    destination = "/etc/salt/minion"
  }

  provisioner "shell" {
    inline = [
      "salt-call state.apply chezmoi,nvim-plugins -l debug --state-output=changes",
    ]
  }

  provisioner "shell" {
    inline = [
      "apt-get purge salt-common salt-minion curl -y",
      "apt-get autoremove -y",
      "rm -rf /var/cache/salt",
      "rm -rf /var/log/salt",
      "rm -rf /var/run/salt",
      "rm -rf /etc/salt",
      "rm -rf /srv/salt",
      "pip3 uninstall pygit2 -y",
    ]
  }

  post-processor "docker-tag" {
    repository = "rsutton1"
    tag        = ["nvim-root"]
  }

}

build {

  name = "devbox"

  source "source.docker.ubuntu" {
    image = "rsutton1:nvim-root"
    pull  = false
    changes = [
      "ENTRYPOINT ./entrypoint.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "chmod -R 777 /root",
    ]
  }

  provisioner "file" {
    source      = "packer/entrypoint.sh"
    destination = "/entrypoint.sh"
  }

  post-processor "docker-tag" {
    repository = "rsutton1"
    tag        = ["nvim"]
  }

}

build {

  name = "devbox-onebuild"

  source "source.docker.ubuntu" {
    image = "ubuntu:latest"
    changes = [
      "ENTRYPOINT ./entrypoint.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /srv/salt/",
      "mkdir -p /etc/salt/",
      "mkdir -p /etc/apt/keyrings",
    ]
  }

  provisioner "file" {
    source      = "salt/files/pygit.sls"
    destination = "/srv/salt/pygit.sls"
  }

  provisioner "file" {
    source      = "packer/entrypoint.sh"
    destination = "/entrypoint.sh"
  }

  provisioner "file" {
    source      = "salt/files"
    destination = "/srv/salt/files"
  }

  provisioner "file" {
    source      = "salt/pillar"
    destination = "/srv/salt/pillar"
  }

  provisioner "file" {
    source      = "salt/system"
    destination = "/etc/salt/minion.new"
  }

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install curl -y",
      "curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg",
      "echo \"deb [signed-by=/etc/apt/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/latest focal main\" | tee /etc/apt/sources.list.d/salt.list",
      "apt-get update",
      "apt-get install salt-minion -y",
      "mv /etc/salt/minion.new /etc/salt/minion",
      "salt-call --local state.apply pygit -l quiet # for gitfs",
      "salt-call state.apply chezmoi,nvim-plugins -l debug --state-output=changes",
      "apt-get purge salt-common salt-minion curl python3 -y",
      "apt-get autoremove -y",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",
      "rm -rf /var/cache/salt",
      "rm -rf /var/log/salt",
      "rm -rf /var/run/salt",
      "rm -rf /etc/salt",
      "rm -rf /srv/salt",
      "rm -rf /tmp/",
      "chmod -R 777 /root",
    ]
  }

  post-processor "docker-tag" {
    repository = "rsutton1"
    tag        = ["nvim"]
  }

}
