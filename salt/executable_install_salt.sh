#!/bin/bash

# validate platform is supported
platform=$(uname)
if [ "$platform" != "Linux" ]; then
    echo "Automated Salt install only supported on: Linux, Debian. Exiting..."
    exit 1
fi

cd "$(dirname ${BASH_SOURCE[0]})"

# vars
SALT_VENV_DIR=~/salt_venv
SALT_VERSION=3004
SALT_SYMLINK_DIR=/usr/local/bin

# install salt into virtualenv
if [ -f $SALT_SYMLINK_DIR/salt-call ]; then
    echo "salt-call already installed at $SALT_SYMLINK_DIR/salt-call. Exiting..."
    exit 0
fi
sudo apt-get install python3-venv -y
python3 -m venv $SALT_VENV_DIR
sudo $SALT_VENV_DIR/bin/pip3 install markupsafe==2.0.1 jinja2==3.0 wheel
sudo $SALT_VENV_DIR/bin/pip3 install salt==$SALT_VERSION
PRIORITY=$(echo $SALT_VERSION | sed "s/\.//g")
sudo update-alternatives --install $SALT_SYMLINK_DIR/salt-call salt-call $SALT_VENV_DIR/bin/salt-call $PRIORITY
sudo update-alternatives --set salt-call $SALT_VENV_DIR/bin/salt-call
