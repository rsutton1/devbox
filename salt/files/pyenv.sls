{% set user = salt.environ.get("SUDO_USER") %}

pyenv-deps:
  pkg.installed:
    - pkgs:
      - make
      - build-essential
      - libssl-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      - wget
      - curl
      - llvm

python-3.8.13:
  pyenv.installed:
    - default: True
    - user: {{ user }}
    - require:
      - pkg: pyenv-deps
