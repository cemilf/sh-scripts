#!/bin/sh

# Sources:
#         - https://medium.com/faun/kubernetes-prerequisites-for-setup-kubenetes-cluster-part-2-699b3f93d6cc


# Configure IP Tables
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Disable swap memory
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


# Add the Kubernetes signing key to both systems
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add

# Add the Kubernetes package repository
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main"

## Install Kubernetes and  NFS Client Drivers
apt update
apt install kubeadm kubelet kubectl kubernetes-cni nfs-common software-properties-common -y
apt-mark hold kubelet kubeadm kubectl
systemctl daemon-reload
systemctl restart kubelet


# Open /etc/fstab and comment out the /swapfile line or run the command
# nano /etc/fstab

## Create Default Audit Policy

mkdir -p /etc/kubernetes
cat > /etc/kubernetes/audit-policy.yaml <<EOF
apiVersion: audit.k8s.io/v1beta1
kind: Policy
rules:
- level: Metadata
EOF

# Create folder to save audit logs
mkdir -p /var/log/kubernetes/audit




# Check that all servers have different mac addresses
#ip link

# Check that all servers have a different product ID
#sudo cat /sys/class/dmi/id/product_uuid



# set hostnames
# hostnamectl set-hostname kubernetes-master

# Initialize Kubernetes master server
# kubeadm init --control-plane-endpoint "vip-k8s-master:8443" --upload-certs


# To enable regular user to start using the Kubernetes cluster run these commands
# mkdir -p $HOME/.kube
# cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# chown $(id -u):$(id -g) $HOME/.kube/config

# If you are the root user, you can run:
# export KUBECONFIG=/etc/kubernetes/admin.conf

# Deploy a pod network
# The pod network is used for communication between hosts and is necessary for the Kubernetes cluster to function properly
# Depending on your environment, it may take just a few seconds or a minute to bring the entire flannel network up

# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# Deploy Calico
# curl https://docs.projectcalico.org/manifests/calico.yaml -O
# Uncomment the CALICO_IPV4POOL_CIDR variable in the manifest and set it to the same value as your chosen pod CIDR.


# Confirm that everything is up and ready
# kubectl get pods --all-namespaces
# kubectl apply -f calico.yaml

# Join the Kubernetes cluster