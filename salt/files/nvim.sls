{% set user = salt.environ.get("SUDO_USER") %}
{% set nvim_basedir = "/opt/nvim" %}
{% set nvim_dir = nvim_basedir + "/v0.7.2" %}
{% set nvim_current = nvim_basedir + "/current" %}
{% set nvim_path = nvim_current + "/bin/nvim" %}
include:
 - node.archive

{% if grains['kernel'] == 'Linux' %}
neovim_downloaded:
  archive.extracted:
    - name: {{ nvim_dir }}
    - trim_output: 0
    - source: https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz
    - source_hash: fa75852890ca4b57551da194c696d3bbd14d9d2e966bc188d1e7e52ee942b71d
    - hide_output: True
neovim_current:
  file.symlink:
    - name: {{ nvim_current }}
    - target: "{{ nvim_dir }}/nvim-linux64"
    - force: True
    - onchanges:
      - neovim_downloaded
neovim_installed:
  file.copy:
    - name: /usr/local/
    - recurse: True
    - source: {{ nvim_current }}
    - require:
      - neovim_current
neovim_path:
  file.blockreplace:
    - name: /home/{{ user }}/.bashrc
    - content: 'export PATH="{{ nvim_current }}/bin:$PATH"'
    - marker_start: "## salt managed -- nvim start"
    - marker_end: "## salt managed -- nvim end"
    - append_if_not_found: True
    - require:
      - neovim_current
{% endif %}

neovim_ag_installed:
  pkg.installed:
    - pkgs:
      - silversearcher-ag

neovim_plugins_vimplug:
  cmd.run:
    - name: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - runas: {{ user }}
    - require:
      - neovim_installed
      - node-archive-install-file-symlink-node # for coc
      - neovim_ag_installed

neovim_plugins_installed:
  cmd.run:
    - name: {{ nvim_path }} --headless +PlugInstall +qa
    - runas: {{ user }}
    - require:
      - neovim_plugins_vimplug
