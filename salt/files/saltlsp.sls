{% set user = salt.environ.get("SUDO_USER") %}
include:
 - pyenv

salt_lsp:
  pip.installed:
    - name: salt-lsp
    - bin_env: /home/{{ user }}/.pyenv/versions/3.8.13/bin/pip3
