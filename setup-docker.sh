#!/bin/bash
set -ex
export DEBIAN_FRONTEND=noninteractive

#apt remove docker docker-engine docker.io containerd runc

apt update
apt upgrade
apt install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker ubuntu
newgrp docker
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker