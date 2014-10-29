# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # virtualbox config options -> http://www.virtualbox.org/manual/ch08.html
  config.vm.provider :virtualbox do |vb|
    # total ram
    vb.customize ["modifyvm", :id, "--memory", 1024]
    # video ram
    vb.customize ["modifyvm", :id, "--vram", 8]
    # number of cpus cores
    vb.customize ["modifyvm", :id, "--cpus", 4]
    # cpu core availability (percentage)
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", 100]
  end

  # Create a public network interface allowing the VM
  # to function as another device on the network
  config.vm.network :private_network, :ip => "10.0.0.10"

  # mount my home directory
  config.vm.synced_folder `echo ~`.chomp, "/home/vagrant/Home"

  # forward auth keys for easy githubbin, server connections
  config.ssh.forward_agent = true

  # update all existing packages
  # set session as noninteractive for the upgrade
  # so that gui installers don't mess up the terminal
  # config.vm.provision :shell, :inline => "sudo apt-get update &> /dev/null && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade"

  # do what ya like
  config.vm.provision :shell, :path => "provision.sh"

end
