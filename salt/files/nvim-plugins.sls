include:
  - nvim
  - chezmoi
  - node.archive

git_installed:
  pkg.installed:
    - name: git
    - require_in:
      - neovim_plugins_installed

silversearcher:
  pkg.installed:
    - name: silversearcher-ag
    - require_in:
      - neovim_plugins_installed

coc_requisite:
  test.nop:
    - require:
      - node-archive-install-file-symlink-node # for coc
      - chezmoi_diff # to create nvim config
    - require_in:
      - neovim_plugins_installed

