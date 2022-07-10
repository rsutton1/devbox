{% set user = salt.environ.get("SUDO_USER") %}
{% set user_home = "/home/" + user %}

rbenv-deps:
  pkg.installed:
    - names:
      - bash
      - git
      - openssl
      - libssl-dev
      - make
      - curl
      - autoconf
      - bison
      - build-essential
      - libffi-dev
      - libyaml-dev
      - libreadline-dev
      - zlib1g-dev
      - libncurses5-dev

2.6.10:
  rbenv.installed:
    - default: True
    - user: {{ user }}
    - require:
      - pkg: rbenv-deps

rbenv_bashrc_init:
  file.blockreplace:
    - name: {{ user_home }}/.bashrc
    - marker_start: "# start salt managed rbenv.sls"
    - marker_end:  "# end salt managed rbenv.sls"
    - content: |
        export PATH=~/.rbenv/bin:~/.rbenv/shims:$PATH
        eval "$(rbenv init - bash)"
    - append_if_not_found: True
