apt update && apt upgrade -y
apt install -y curl 
curl -sfL https://get.k3s.io | sh -

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# wget -O - https://github.com/helm/helm/raw/refs/heads/main/scripts/get-helm-3 | sh

# set env variable for kubeconfig
echo "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/environment

# create namespaces
kubectl create namespace cert-manager
kubectl create namespace rancher

# add helm repos
helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

# install cert manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.11.01

# install rancher
helm install rancher rancher-stable/rancher \
  --namespace rancher \
  --set hostname=192.168.1.65 \
  --set bootstrapPassword=admin