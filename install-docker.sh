#!/bin/sh
# A script for installing docker on Ubuntu

# Update existing packege list
apt update

# Upgrade packages 
apt upgrade -y
apt full-upgrade -y
apt install unattended-upgrades -y

# Remove old Docker versions if exists
apt remove -y docker docker-engine docker.io containerd runc

# Update existing packege list
apt update

# Install prerequisite packages before installing Docker
apt install  -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg2 \
    gnupg-agent

# Add the GPG key for the official Docker repository to your system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add the Docker repository to APT sources
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"

# Update the package database with the Docker packages from the newly added repo
apt update

# Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
apt-cache policy docker-ce

# Install Docker, Docker cli and containerd
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

# Reload daemon and enable Docker service
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

# Check the status of docker service
systemctl status docker

# Check the version of Docker
docker --version

# Executing the Docker Command Without Sudo
# Add your username to the docker group
usermod -aG docker ${USER }
su - ${USER}
id -nG
