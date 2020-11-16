#!/bin/bash -xe

echo 'System update'
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
echo 'Installing docker'
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce

echo 'Installing docker compose'
sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo 'Grant access for user Vagrant'
sudo usermod -aG docker vagrant
