# -*- coding: utf-8 -*-
# vim: ft=yaml
---
nvm:
  install_path: /home/{{ salt.environ.get("SUDO_USER") }}/.nvm
  install_user: {{ salt.environ.get("SUDO_USER") }}
