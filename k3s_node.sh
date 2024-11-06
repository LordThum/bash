while getopts h:p: flag
do
    case "${flag}" in
        u) url=${OPTARG};;
        t) token=${OPTARG};;
    esac
done

# update ind install curl
apt update && apt upgrade -y
apt install -y curl 

 # install k3s node with master url and token 
 # dont forget port 6443 on in url
curl -sfL https://get.k3s.io | K3S_URL=$url K3S_TOKEN=$token sh -