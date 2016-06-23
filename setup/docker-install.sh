#!/bin/sh

echo "INFO: [docker-install.sh] importing gpg key from dockerproject"
sudo rpm --import https://yum.dockerproject.org/gpg
sudo yum clean all
sudo yum update -y -q
sudo cp /home/vagrant/sync/setup/yum.repos.d/* /etc/yum.repos.d/

echo "INFO: [docker-install.sh] install docker-engine"
sudo yum install -y -q docker-engine
