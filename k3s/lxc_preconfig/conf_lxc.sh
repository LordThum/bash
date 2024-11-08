while getopts i: flag
do
    case "${flag}" in
        i) cid=${OPTARG};;
    esac
done

printf "lxc.apparmor.profile: unconfined \nlxc.cgroup.devices.allow: a \nlxc.cap.drop: \nlxc.mount.auto: "proc:rw sys:rw"" >> /etc/pve/lxc/$cid.conf

pct push $cid <file> /etc/

pct enter $cid
chmod +x /etc/rc.local
reboot
