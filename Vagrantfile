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

VAGRANTFILE_API_VERSION = "2"

ipv4 = OSLV_PVTNET.split('.')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # supported box adrianovieira/centos7
  config.vm.box = "adrianovieira/centos7-docker1.12rc4"
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

  config.vm.define "manager1" do |manager|  # define-VM swarm-manager1
    # vagrant plugin install vagrant-hosts vagrant-hostsupdater
    # if plugins installed also set /etc/hosts
    OSLV_MANAGER_FQDN = "manager1" #"#{OSLV_NAME}-manager1.#{OSLV_DOMAIN}"
    manager.vm.host_name = "#{OSLV_MANAGER_FQDN}"
    manager.vm.network "private_network", ip: OSLV_PVTNET

    manager.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
      virtualbox.customize [ "modifyvm", :id, "--cpus", OSLV_CPU ]
      virtualbox.customize [ "modifyvm", :id, "--memory", OSLV_MEMORY ]
      virtualbox.customize [ "modifyvm", :id, "--name", OSLV_MANAGER_FQDN ]
      virtualbox.customize [ "modifyvm", :id, "--groups", "/#{OSLV_GROUP}" ]
    end # end Virtualbox.settings

    manager.vm.provision "hostname_setup", type: "shell",
            inline: "sudo hostnamectl set-hostname #{OSLV_MANAGER_FQDN}"

    manager.vm.provision "docker_restart", type: "shell",
            inline: "sudo systemctl daemon-reload ; sudo systemctl restart docker"

    manager.vm.provision "docker-setup-swarm", type: "shell" do |sh|
      sh.path = "setup/docker-setup-swarm_manager.sh"
      sh.args   = ["#{OSLV_PVTNET}", "2377"]
    end # end docker-setup-swarm_manager provision

    #manager.vm.provision "docker-swarm_test", type: "shell", path: "setup/docker-setup-swarm_test.sh"

  end # end-of-define-VM swarm-manager1

  (1..2).each do |worker_id|
    config.vm.define "worker#{worker_id}" do |worker|  # define-VM swarm-worker1
      # plugin https://github.com/oscar-stack/vagrant-hosts
      # if plugin installed also set /etc/hosts
      worker_fdqn = "worker#{worker_id}" #"#{OSLV_NAME}-worker#{worker_id}.#{OSLV_DOMAIN}"
      worker_ipv4 = [ipv4[0], ipv4[1],ipv4[2], (ipv4[3].to_i+worker_id)>=250?(ipv4[3].to_i-worker_id):ipv4[3].to_i+worker_id ].join('.')
      worker.vm.network "private_network", ip: worker_ipv4

      worker.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
        virtualbox.customize [ "modifyvm", :id, "--cpus", OSLV_CPU ]
        virtualbox.customize [ "modifyvm", :id, "--memory", OSLV_MEMORY ]
        virtualbox.customize [ "modifyvm", :id, "--name", worker_fdqn ]
        virtualbox.customize [ "modifyvm", :id, "--groups", "/#{OSLV_GROUP}" ]
      end # end Virtualbox.settings

      worker.vm.provision "hostname_setup", type: "shell",
                inline: "sudo hostnamectl set-hostname #{worker_fdqn}"

      worker.vm.provision "docker_restart", type: "shell",
              inline: "sudo systemctl daemon-reload ; sudo systemctl restart docker"

      worker.vm.provision "docker-setup-swarm", type: "shell" do |sh|
        sh.path = "setup/docker-setup-swarm_worker.sh"
        sh.args   = ["#{OSLV_PVTNET}", "2377"]
      end # end docker-setup-swarm_worker provision

    end # end-of-define-VM swarm-worker
  end # end-of-define-VM-loop worker_id

  config.vm.provision "docker-setup-proxy", type: "shell", path: "setup/docker-setup-proxy.sh"

end # end-of-file
