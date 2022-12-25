include:
  - nvim
  - node.archive

silversearcher:
  pkg.installed:
    - name: silversearcher-ag
    - require_in:
      - neovim_plugins_installed

coc_requisite:
  test.nop:
    - require:
      - node-archive-install-file-symlink-node # for coc
    - require_in:
      - neovim_plugins_installed

