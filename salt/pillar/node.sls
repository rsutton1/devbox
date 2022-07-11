# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- set user = salt.environ.get("SUDO_USER") -%}
{%- set user_home = "/home/" + user %}
#---
node:
  # This version is used in archive/source installations, and it's major number
  # is used in to build the upstream's repo URL when using package installations
  # (the default) and `use_upstream_repo: true`
  version: 16.13.0
  config:
    prefix: '{{ user_home }}/npm-packages'
#  environ:
#    a: b
  pkg:
#    # This version is used only in `package` based installations, to pin to
#    # specific package version, specially if the repo has more than one available
#    # version: 16.13.0
    use_upstream_repo: true
    use_upstream_archive: true
    use_upstream_source: true
    archive:
      uri: https://nodejs.org/dist
      source_hash: 9c00e5b6024cfcbc9105f9c58cf160762e78659a345d100c5bd80a7fb38c684f
    source:
      uri: https://github.com/nodejs/node/archive
      source_hash: f0327e99f730bf2506a1f13dbd452ec80b33667a7ce1c77a2dacd6babc8643c7
