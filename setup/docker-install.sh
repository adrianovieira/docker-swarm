#!/bin/bash

if [[ -f /etc/os-release  ]]; then
  . /etc/os-release
fi

if [[ "$ID" == "centos" && "$VERSION_ID" == "7" ]]; then
  echo "INFO: [docker-install.sh] importing gpg key from dockerproject"
  sudo rpm --import https://yum.dockerproject.org/gpg
  sudo yum clean all
  sudo yum update -y -q
  sudo cp /home/vagrant/sync/setup/yum.repos.d/* /etc/yum.repos.d/

  echo "INFO: [docker-install.sh] install docker-engine"
  sudo yum install -y -q docker-engine

  echo "INFO: [docker-install.sh] start docker-engine"
  sudo systemctl enable docker && sudo systemctl start docker
else
  echo "ERROR: [docker-install.sh] OS [$ID-$VERSION_ID] not supported!"
  exit 1
fi
