neovim_build_deps:
  pkg.installed:
    - pkgs:
      - ninja-build
      - gettext
      - libtool
      - libtool-bin
      - autoconf
      - automake
      - cmake
      - g++
      - pkg-config
      - unzip
      - curl
      - doxygen
    - prereq:
      - cmd: neovim_installed

neovim_downloaded:
  archive.extracted:
    - name: /tmp/
    - trim_output: 0
    - source: https://github.com/neovim/neovim/archive/refs/tags/v0.7.0.tar.gz
    - source_hash: 792a9c55d5d5f4a5148d475847267df309d65fb20f05523f21c1319ea8a6c7df
    - prereq:
      - cmd: neovim_installed

neovim_installed:
  cmd.run:
    - name: |
        cd /tmp/neovim-0.7.0
        make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/opt/neovim"
        make install
    - hide_output: True
    - unless: /opt/neovim/bin/nvim --version | grep 0.7.0

deps:
  pkg.installed:
    - pkgs:
      - tmux
      - silversearcher-ag
