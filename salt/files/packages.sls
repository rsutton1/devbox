neovim_archive:
  archive.extracted:
    - name: /usr/local/bin/
    - trim_output: 0
    - source: https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz
    - source_hash: 5b3fced3f185ae1e1497cb5f949597c4065585fc26e7cd25a31f5f791dbd9b59
    - options: --extract nvim-linux64/bin/nvim --strip-components=2
    - enforce_toplevel: False

deps:
  pkg.installed:
    - pkgs:
      - tmux
      - silversearcher-ag
