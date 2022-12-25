#!/bin/bash

sudo salt-call state.apply pygit -l quiet # for gitfs
sudo salt-call state.sls_id chezmoi_init chezmoi # to show chezmoi diff
sudo chmod -R 777 var/ 2> /dev/null || true
