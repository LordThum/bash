start() {
    if ! (whiptail --backtitle "Proxmox VE Helper Scripts" --title "APP LXC" --yesno "This will create a New APP LXC. Proceed?" 10 58); then
      clear
      echo -e "⚠  User exited script \n"
      exit
    fi
    install_script
}

default_settings() {
    clear
    pct create 120 /var/lib/vz/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
    -arch amd64 \
    -ostype ubuntu \
    -hostname lxc-test \
    -cores 1 \
    -memory 512 \
    -swap 0 \
    -storage local-lvm \
    -rootfs local-lvm:10 \
    -password admin \
    -net0 name=eth0,bridge=vmbr0,ip=dhcp
}

advanced_settings() {
    HOSTNAME=$(whiptail --backtitle "Create LXC" --inputbox "Set Container Hostname" 8 58 --title "Hostname" 3>&1 1>&2 2>&3)
    CID=$(whiptail --backtitle "Create LXC" --inputbox "Set Container ID" 8 58 --title "Container ID" 3>&1 1>&2 2>&3)
    CORES=$(whiptail --backtitle "Create LXC" --inputbox "Set CPU Cores" 8 58 --title "CPU Cores" 3>&1 1>&2 2>&3)
    MEMORY=$(whiptail --backtitle "Create LXC" --inputbox "Set Container RAM" 8 58 --title "Container RAM" 3>&1 1>&2 2>&3)
    IP=$(whiptail --backtitle "Create LXC" --inputbox "Set Container IP Adress" 8 58 --title "Network IP" 3>&1 1>&2 2>&3)
    GATEWAY=$(whiptail --backtitle "Create LXC" --inputbox "Set Gateway" 8 58 --title "Network Gateway " 3>&1 1>&2 2>&3)
    ROOTPW=$(whiptail --backtitle "Create LXC" --passwordbox "Set Root Password" 8 58 --title "Root Password" 3>&1 1>&2 2>&3)

    clear

    pct create $CID /var/lib/vz/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
    -arch amd64 \
    -ostype ubuntu \
    -hostname $HOSTNAME \
    -cores $CORES \
    -memory $MEMORY \
    -swap 0 \
    -storage local-lvm \
    -rootfs local-lvm:10 \
    -password $ROOTPW \
    -net0 name=eth0,bridge=vmbr0,gw=$GATEWAY,ip=$IP/24,type=veth
}

install_script() {
    clear
    if (whiptail --title "Settings" --yesno "Use default Setting?" 8 78); then
        default_settings
    else
        advanced_settings
    fi
}

start