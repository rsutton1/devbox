python3_pip:
  pkg.installed:
    - name: python3-pip
pygit:
  pip.installed:
    - name: pygit2
    - require:
      - python3_pip
