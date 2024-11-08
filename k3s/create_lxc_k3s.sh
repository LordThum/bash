#!/bin/bash

source /dev/stdin <<< "$(curl -s https://github.com/LordThum/bash/raw/refs/heads/main/k3s/lxc_preconfig/conf_lxc.sh)"
source /dev/stdin <<< "$(curl -s https://github.com/LordThum/bash/raw/refs/heads/main/proxmox/create_lxc.sh)"

start
preconfig