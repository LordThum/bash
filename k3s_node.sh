apt update && apt upgrade -y
apt install -y curl 

# lxc configuration


curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.60:6443 K3S_TOKEN=K1023a3b7e7fbe59c0df716d8262bfa1b2d40e81d74268f83e07470ebf220254eb6::server:165549a433c38c8b1ee9b8b017b4d7a3 sh -