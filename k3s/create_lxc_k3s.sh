#!/bin/bash

source <(curl -s https://github.com/LordThum/bash/raw/refs/heads/main/k3s/lxc_preconfig/conf_lxc.func)

wget -O - https://github.com/LordThum/bash/raw/refs/heads/main/proxmox/create_lxc.sh | sh
preconfig