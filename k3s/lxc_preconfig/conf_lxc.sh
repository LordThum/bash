while getopts i: flag
do
    case "${flag}" in
        i) cid=${OPTARG};;
    esac
done

printf "lxc.apparmor.profile: unconfined \nlxc.cgroup.devices.allow: a \nlxc.cap.drop: \nlxc.mount.auto: "proc:rw sys:rw"" >> /etc/pve/lxc/$cid.conf

pct start 110 
pct exec 110 -- bash -c "wget -O /etc/rc.local - https://github.com/LordThum/bash/raw/refs/heads/main/k3s/lxc_preconfig/rc.local"
pct exec 110 -- bash -c "chmod +x /etc/rc.local"
pct exec 110 reboot