#!/bin/bash

# Script for ec2 user data to setup Docker.

# Scripts entered as user data are run as the root user.
# Also, because the script is not run interactively, you cannot include commands that require user feedback (such as apt update without the -y flag).
# More: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-console

set -ex
export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker ubuntu
newgrp docker
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker
