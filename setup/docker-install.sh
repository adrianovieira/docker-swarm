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

elif [[ "$ID" == "ubuntu" && "$VERSION_ID" == "14.04" ]]; then
  echo "INFO: [docker-install.sh] importing gpg key from dockerproject"
  sudo cp /home/vagrant/sync/setup/apt.source.list/docker-ubuntu-trusty.list /etc/apt/sources.list.d/docker.list

  echo "INFO: [docker-install.sh] install docker-engine"
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  sudo apt-get -qq autoclean
  sudo apt-get -qq update
  sudo apt-get -qq -y install language-pack-pt docker-engine

  echo "INFO: [docker-install.sh] status docker-engine"
  service docker status
  if [[ "$?" == "1" ]]; then
    echo "INFO: [docker-install.sh] start docker-engine"
    sudo service docker start
  fi

else
  echo "ERROR: [docker-install.sh] OS [$ID-$VERSION_ID] not supported!"
  exit 1
fi
