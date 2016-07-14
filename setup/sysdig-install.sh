#!/bin/bash

if [[ -f /etc/os-release  ]]; then
  . /etc/os-release
fi

if [[ "$ID_LIKE" == "redhat" ]]; then
  echo "INFO: [sysdig-install.sh] settingup base repo of sysdig"
  sudo rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public
  sudo curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo

  sudo rpm -i http://mirror.us.leaseweb.net/epel/6/i386/epel-release-6-8.noarch.rpm

  echo "INFO: [sysdig-install.sh] install linux kernel headers"
  sudo yum -y install kernel-devel-$(uname -r)

  echo "INFO: [sysdig-install.sh] install sysdig"
  sudo yum -y install sysdig

elif [[ "$ID_LIKE" == "debian" ]]; then
  echo "INFO: [sysdig-install.sh] settingup base repo of sysdig"
  sudo curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
  sudo curl -s -o /etc/apt/sources.list.d/draios.list http://download.draios.com/stable/deb/draios.list
  sudo apt-get update

  echo "INFO: [sysdig-install.sh] install linux kernel headers"
  sudo apt-get -y install linux-headers-$(uname -r)

  echo "INFO: [sysdig-install.sh] install sysdig"
  sudo apt-get -y install sysdig

else
  echo "ERROR: [sysdig-install.sh] OS [$ID-$VERSION_ID] not supported!"
  exit 1
fi

echo "INFO: [sysdig-install.sh] finished successfuly"
