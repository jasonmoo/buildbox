# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "box-cutter/ubuntu1404"

  # virtualbox config options -> http://www.virtualbox.org/manual/ch08.html
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "1024"
    v.vmx["numvcpus"] = "2"
  end

  # Create a public network interface allowing the VM
  # to function as another device on the network
  config.vm.network :private_network, :ip => "10.0.0.10"

  # mount my home directory
  config.vm.synced_folder `echo ~`.chomp, "/home/vagrant/Home"

  # forward auth keys for easy githubbin, server connections
  config.ssh.forward_agent = true

  # do what ya like
  config.vm.provision :shell, :path => "provision.sh"

end
