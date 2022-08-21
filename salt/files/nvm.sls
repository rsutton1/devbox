include:
  - nvm.source

nvm_chown:
  file.directory:
    - name: {{ salt.config.get("nvm:install_path") }}
    - user: {{ salt.config.get("nvm:install_user") }}
    - recurse:
      - user
      - silent
    - require:
      - nvm_profile
