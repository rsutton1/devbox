#!/bin/bash
set -x

USER_ID=${USER_ID:-1000}
GROUP_ID=${GROUP_ID:-1000}

addgroup --gid "$GROUP_ID" user
adduser --home /root --disabled-password --gecos '' --uid "$USER_ID" --gid "$GROUP_ID" user
su user -c "cd /code && /opt/nvim/current/bin/nvim"
