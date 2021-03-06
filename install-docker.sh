#!/bin/sh
# A script for installing docker on Ubuntu

apt update
apt upgrade -y
apt full-upgrade -y
apt install unattended-upgrades -y
apt remove -y docker docker-engine docker.io containerd runc

apt update

apt install  -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg2 \
    gnupg-agent

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"

apt update
apt install -y \
       docker-ce \
       docker-ce-cli \
       containerd.io

mkdir -p /etc/systemd/system/docker.service.d

tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker
docker --version

usermod -aG docker ${USER }
su - ${USER}
id -nG
