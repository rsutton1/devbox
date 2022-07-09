{% set user = salt.environ.get("SUDO_USER") %}

nvim-salt-lsp:
  pip.installed:
    - name: salt-lsp
    - bin_env: /home/{{ user }}/.pyenv/versions/3.8.13/bin/pip3
