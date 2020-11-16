#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

echo "System update"
sudo apt-get update
sudo apt-get install -y jq nano
sudo apt-get update
sudo apt-get -y autoclean

export data=/home/vagrant/data

echo "Provisioning docker"
if [ ! -f /vagrant/scripts/docker.sh ]; then
    echo "File /vagrant/scripts/docker.sh not found!" >&2
    exit 1
fi

echo "Changing access"
chmod 777 /vagrant/scripts/docker.sh
if [ $? -ne 0 ]; then
    exit 1
fi

echo "Executing /vagrant/scripts/docker.sh"
su vagrant /vagrant/scripts/docker.sh
if [ $? -ne 0 ]; then
    exit 1
fi
