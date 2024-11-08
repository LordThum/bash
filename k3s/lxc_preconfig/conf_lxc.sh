#!/bin/bash

TEST="das ist ein test"

preconfig() {
    printf "lxc.apparmor.profile: unconfined \nlxc.cgroup.devices.allow: a \nlxc.cap.drop: \nlxc.mount.auto: "proc:rw sys:rw"" >> /etc/pve/lxc/$CID.conf

    pct start $CID 
    pct exec $CID -- bash -c "wget -O /etc/rc.local - https://github.com/LordThum/bash/raw/refs/heads/main/k3s/lxc_preconfig/rc.local"
    pct exec $CID -- bash -c "chmod +x /etc/rc.local"
    pct exec $CID reboot
}