CID=0

create_container() {
    CID=$(pvesh get /cluster/nextid)
    ROOTPW=$(whiptail --backtitle "Create LXC" --passwordbox "Set Root Password" 8 58 --title "Root Password" 3>&1 1>&2 2>&3)
    clear

    pct create $CID /var/lib/vz/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
    -arch amd64 \
    -ostype ubuntu \
    -cores 1 \
    -memory 512 \
    -swap 0 \
    -storage local-lvm \
    -rootfs local-lvm:10 \
    -password $ROOTPW \
    -net0 name=eth0,bridge=vmbr0,ip=dhcp
}

lxc_preconfig() {
    printf "lxc.apparmor.profile: unconfined \nlxc.cgroup.devices.allow: a \nlxc.cap.drop: \nlxc.mount.auto: "proc:rw sys:rw"" >> /etc/pve/lxc/$CID.conf

    pct start $CID 
    pct exec $CID -- bash -c "wget -O /etc/rc.local - https://github.com/LordThum/bash/raw/refs/heads/main/k3s/lxc_preconfig/rc.local"
    pct exec $CID -- bash -c "chmod +x /etc/rc.local"
    pct exec $CID reboot
}

install_k3s() {
    pct exec $CID -- bash -c "
        apt update && apt upgrade -y && \
        apt install -y curl git && \
        curl -sfL https://get.k3s.io | sh -"
}

install_rancher() {
    HOSTNAME=$(whiptail --backtitle "K3S" --inputbox "Set Container Hostname" 8 58 --title "Hostname" 3>&1 1>&2 2>&3)
    RANCHERPW=$(whiptail --backtitle "K3S" --passwordbox "Set Bootstrap Password" 8 58 --title "Password" 3>&1 1>&2 2>&3)

    # install helm 
    pct exec $CID -- bash -c "
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
        achmod 700 get_helm.sh\
        ./get_helm.sh"

    # set env variable for kubeconfig
    pct exec $CID -- bash -c "
        export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && \
        chmod 755 /etc/rancher/k3s/k3s.yaml"

    # create namespaces
    pct exec $CID -- bash -c "
        kubectl create namespace cert-manager && \
        kubectl create namespace rancher"

    # add helm repos
    pct exec $CID -- bash -c "
        helm repo add jetstack https://charts.jetstack.io && \
        helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && \
        helm repo update"

    # install cert manager
    pct exec $CID -- bash -c "
        kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml && \
        helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.11.01"

    # install rancher
    pct exec $CID -- bash -c "
        helm install rancher rancher-stable/rancher \
            --namespace rancher \
            --set hostname=$HOSTNAME \
            --set bootstrapPassword=$RANCHERPW "
}


start() {
    create_container
    lxc_preconfig

    sleep 10 &
    
    install_k3s

    if ! (whiptail --backtitle "K3S" --title "Rancher" --yesno "Do You want to install Rancher?" 10 58); then
      clear
      exit
    fi
    install_rancher
}

start