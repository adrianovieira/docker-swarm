'''
/**
 * Tasting docker in swarm mode (1.12+)
 *
 * Vagrantfile for Linux Containers Docker-Swarm (Operating System Level Virtualization)
 * @author Adriano Vieira <adriano.svieira at gmail.com>
 * @license @see LICENCE
 */
 '''

# VM BASE NAME on virtualbox (default: OSLV-node-dev_tests)
OSLV_NAME = (ENV.key?('OSLV_NAME') ? ENV['OSLV_NAME'] : "oslv-swarm").downcase

# VM memory on virtualbox (default: 2048MB)
OSLV_MEMORY = ENV.key?('OSLV_MEMORY') ? ENV['OSLV_MEMORY'] : 2048

# VM cpu/cores on virtualbox (default: 1 cpu/core)
OSLV_CPU = ENV.key?('OSLV_CPU') ? ENV['OSLV_CPU'] : 1

# VM domain suffix (default: hacklab)
OSLV_DOMAIN = (ENV.key?('OSLV_DOMAIN') ? ENV['OSLV_DOMAIN'] : "hacklab").downcase

# VM private network (default: 10.0.3.10)
OSLV_PVTNET = ENV.key?('OSLV_PVTNET') ? ENV['OSLV_PVTNET'] : "192.168.50.10"

# VM group (default: OSLV)
OSLV_GROUP = (ENV.key?('OSLV_GROUP') ? ENV['OSLV_GROUP'] : "Docker-Swarm").downcase

# VM fqdn
OSLV_FQDN = "#{OSLV_NAME}.#{OSLV_DOMAIN}"

# vagrant-proxyconf: https://tmatilai.github.io/vagrant-proxyconf
# if necessary set OS environment variable PROXY|HTTP_PROXY|HTTPS_PROXY="http://proxy:port"
if ENV.key?('PROXY')
  HTTP_PROXY=ENV['PROXY']
elsif ENV.key?('proxy')
  HTTP_PROXY=ENV['proxy']
else
  print Vagrant.has_plugin?("vagrant-proxyconf") ?
        "WARN: you installed vagrant-proxyconf plugin, "+
        "but proxy environment variable (PROXY) not set yet!\n\n" : ''

  HTTP_PROXY="http://proxy_not_set:3128"
end
HTTPS_PROXY=HTTP_PROXY

VAGRANTFILE_API_VERSION = "2"

ipv4 = OSLV_PVTNET.split('.')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # ubuntu/trusty64 debian/jessie64 centos/7
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/home/vagrant/sync", type: "rsync"

  # vagrant plugin install vagrant-hosts vagrant-hostsupdater
  # if plugins installed also set /etc/hosts
  if Vagrant.has_plugin?("vagrant-hosts")
    config.vm.provision :hosts do |provisioner|
      provisioner.add_localhost_hostnames = false
      provisioner.autoconfigure = true
      provisioner.sync_hosts = true
      #provisioner.add_host OSLV_PVTNET, ['mvps']
    end
  end

  if Vagrant.has_plugin?("vagrant-proxyconf") &&
        (HTTP_PROXY != "http://proxy_not_set:3128") # proxy settings

    config.proxy.http     = HTTP_PROXY
    config.proxy.https    = HTTPS_PROXY

    print "proxy settings: \n"
    print " - proxy.http:  "+config.proxy.http+"\n"
    print " - proxy.https: "+config.proxy.https+"\n\n"

  end # end proxy settings

  config.vm.define "manager1" do |manager|  # define-VM swarm-manager1
    # vagrant plugin install vagrant-hosts vagrant-hostsupdater
    # if plugins installed also set /etc/hosts
    OSLV_MANAGER_FQDN = "#{OSLV_NAME}-manager1.#{OSLV_DOMAIN}"
    manager.vm.host_name = "#{OSLV_MANAGER_FQDN}"
    manager.vm.network "private_network", ip: OSLV_PVTNET

    manager.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
      virtualbox.customize [ "modifyvm", :id, "--cpus", OSLV_CPU ]
      virtualbox.customize [ "modifyvm", :id, "--memory", OSLV_MEMORY ]
      virtualbox.customize [ "modifyvm", :id, "--name", OSLV_MANAGER_FQDN ]
      virtualbox.customize [ "modifyvm", :id, "--groups", "/#{OSLV_GROUP}" ]
    end # end Virtualbox.settings

    manager.vm.provision "docker-install", type: "shell" do |sh|
      sh.path = "setup/docker-install.sh"
    end # end docker-install provision

    manager.vm.provision "docker-setup-swarm_manager", type: "shell" do |sh|
      sh.path = "setup/docker-setup-swarm_manager.sh"
      sh.args   = ["#{OSLV_PVTNET}", "2377"]
    end # end docker-setup-swarm_manager provision

  end # end-of-define-VM swarm-manager1

  (1..2).each do |worker_id|
    config.vm.define "worker#{worker_id}" do |worker|  # define-VM swarm-worker1
      # plugin https://github.com/oscar-stack/vagrant-hosts
      # if plugin installed also set /etc/hosts
      worker_fdqn = "#{OSLV_NAME}-worker#{worker_id}.#{OSLV_DOMAIN}"
      worker_ipv4 = [ipv4[0], ipv4[1],ipv4[2], (ipv4[3].to_i+worker_id)>=250?(ipv4[3].to_i-worker_id):ipv4[3].to_i+worker_id ].join('.')
      worker.vm.network "private_network", ip: worker_ipv4

      worker.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
        virtualbox.customize [ "modifyvm", :id, "--cpus", OSLV_CPU ]
        virtualbox.customize [ "modifyvm", :id, "--memory", OSLV_MEMORY ]
        virtualbox.customize [ "modifyvm", :id, "--name", worker_fdqn ]
        virtualbox.customize [ "modifyvm", :id, "--groups", "/#{OSLV_GROUP}" ]
      end # end Virtualbox.settings

      worker.vm.provision "docker-install", type: "shell" do |sh|
        sh.path = "setup/docker-install.sh"
      end # end docker-install provision

      worker.vm.provision "docker-setup-swarm_worker", type: "shell" do |sh|
        sh.path = "setup/docker-setup-swarm_worker.sh"
        sh.args   = ["#{OSLV_PVTNET}", "2377"]
      end # end docker-setup-swarm_worker provision

    end # end-of-define-VM swarm-worker
  end # end-of-define-VM-loop worker_id

end # end-of-file
