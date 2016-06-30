#!/bin/bash

echo "INFO: [puppet-install.sh] puppet install"
if [[ -f /etc/os-release  ]]; then
  . /etc/os-release
fi

if [[ "$ID" == "centos" && "$VERSION_ID" == "7" ]]; then
  sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
  sudo yum install -y puppet-agent
elif [[ "$ID" == "ubuntu" && "$VERSION_ID" == "14.04" ]]; then
  wget --quiet https://apt.puppetlabs.com/puppetlabs-release-pc1-precise.deb
  sudo dpkg -i puppetlabs-release-pc1-precise.deb
  sudo apt-get -qq autoclean
  sudo apt-get -qq update
  sudo apt-get -qq -y install puppet-agent
  sudo apt-get -qq autoremove
elif [[ "$ID" == "debian" && "$VERSION_ID" == "8" ]]; then
  wget --quiet https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
  sudo dpkg -i puppetlabs-release-pc1-jessie.deb
  sudo apt-get -qq autoclean
  sudo apt-get -qq update
  sudo apt-get -qq -y install puppet-agent
  sudo apt-get -qq autoremove
else
  echo "ERROR: [puppet-install.sh] OS [$ID-$VERSION_ID] not supported!"
  exit 1
fi

echo "INFO: [puppet-install.sh] finished successfuly"
