HOSTNAME=$(whiptail --backtitle "K3S" --inputbox "Set Container Hostname" 8 58 --title "Hostname" 3>&1 1>&2 2>&3)
RANCHERPW=$(whiptail --backtitle "K3S" --passwordbox "Set Bootstrap Password" 8 58 --title "Password" 3>&1 1>&2 2>&3)


apt update && apt upgrade -y
apt install -y curl git

# install k3s
curl -sfL https://get.k3s.io | sh -

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# set env variable for kubeconfig
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
chmod 755 /etc/rancher/k3s/k3s.yaml

# create namespaces
kubectl create namespace cert-manager
kubectl create namespace rancher

# add helm repos
helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

# install cert manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.11.01

# install rancher
helm install rancher rancher-stable/rancher \
  --namespace rancher \
  --set hostname=$HOSTNAME \
  --set bootstrapPassword=$RANCHERPW