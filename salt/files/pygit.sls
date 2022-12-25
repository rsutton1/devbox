python3_pip:
  pkg.installed:
    - name: python3-pip
pip_upgrade:
  pip.installed:
    - name: pip
    - upgrade: True
pygit:
  pip.installed:
    - name: pygit2
    - require:
      - python3_pip
      - pip_upgrade
