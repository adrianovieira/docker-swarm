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
  sudo yum install -y -q docker-engine-1.12.0-0.3.rc3.el7.centos

  echo "INFO: [docker-install.sh] start docker-engine"
  sudo systemctl daemon-reload
  sudo systemctl enable docker && sudo systemctl start docker

elif [[ "$ID" == "ubuntu" && "$VERSION_ID" == "14.04" ]]; then
  echo "INFO: [docker-install.sh] importing gpg key from dockerproject"
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  echo "INFO: [docker-install.sh] install docker-engine"
  sudo cp /home/vagrant/sync/setup/apt.source.list/docker-ubuntu-trusty.list /etc/apt/sources.list.d/docker.list
  sudo apt-get -qq autoclean
  sudo apt-get -qq update
  sudo apt-get -qq -y --force-yes install language-pack-pt docker-engine=1.12.0~rc3-0~trusty

  echo "INFO: [docker-install.sh] status docker-engine"
  service docker status
  if [[ "$?" == "1" ]]; then
    echo "INFO: [docker-install.sh] start docker-engine"
    sudo service docker start
  fi

elif [[ "$ID" == "debian" && "$VERSION_ID" == "8" ]]; then
  echo "INFO: [docker-install.sh] importing gpg key from dockerproject"
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  echo "INFO: [docker-install.sh] install docker-engine"
  sudo cp /home/vagrant/sync/setup/apt.source.list/docker-debian-jessie.list /etc/apt/sources.list.d/docker.list
  sudo apt-get install -qq -y apt-transport-https
  sudo apt-get -qq autoclean
  sudo apt-get -qq update
  sudo apt-get -qq -y --force-yes install docker-engine=1.12.0~rc3-0~jessie

  echo "INFO: [docker-install.sh] start docker-engine"
  sudo systemctl enable docker && sudo systemctl start docker

else
  echo "ERROR: [docker-install.sh] OS [$ID-$VERSION_ID] not supported!"
  exit 1
fi

echo "INFO: [docker-install.sh] install docker-compose"
sudo curl -L https://github.com/docker/compose/releases/download/1.8.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "INFO: [docker-install.sh] setup vagrant user as a docker group member"
sudo usermod -G docker vagrant

echo "INFO: [docker-install.sh] finished successfuly"
