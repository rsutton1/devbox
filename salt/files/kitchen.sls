{% set user = salt.environ.get("SUDO_USER") %}
{% set user_home = "/home/" + user %}
include:
 - docker
 - rbenv

path_wsl:
  file.blockreplace:
    - name: {{ user_home }}/.bashrc
    - marker_start: "# start salt managed kitchen.sls"
    - marker_end:  "# end salt managed kitchen.sls"
    - content: |
        export PATH=`echo $PATH | tr ':' '\n' | awk '($0!~/mnt\/c/) {print} ' | tr '\n' ':' && echo`
    - append_if_not_found: True
