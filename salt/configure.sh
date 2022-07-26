#!/bin/bash

sudo salt-call state.apply pygit # for gitfs
sudo salt-call state.sls_id chezmoi_init chezmoi # to show chezmoi diff
