chezmoi_extracted:
  archive.extracted:
    - name: /tmp/chezmoi
    - source: https://github.com/twpayne/chezmoi/releases/download/v2.17.1/chezmoi_2.17.1_linux_amd64.tar.gz
    - enforce_toplevel: False
    - force: True
    - overwrite: True
    - source_hash: d22b64993c124d5dd9a06f6a1113a32749a24d5eaa823f831e737365a1fed9e8

chezmoi_installed:
  file.managed:
    - name: /usr/local/bin/chezmoi
    - source: /tmp/chezmoi/chezmoi
    - onchanges:
      - archive: chezmoi_extracted

chezmoi_attrs:
  file.managed:
    - name: /usr/local/bin/chezmoi
    - mode: 0755
    - require:
      - file: chezmoi_installed

chezmoi_diff:
  cmd.run:
    - name: sudo -u vagrant /usr/local/bin/chezmoi apply
    - runas: vagrant
    - cwd: /home/vagrant
    - stateful:
      - test_name: sudo -u vagrant /usr/local/bin/chezmoi diff
    - require:
      - file: chezmoi_attrs
