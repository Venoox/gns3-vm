# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "file", source: "gns3.service.systemd", destination: "$HOME/gns3.service.systemd"
  config.vm.provision "file", source: "gns3_server.conf", destination: "$HOME/.config/GNS3/2.2/gns3_server.conf"
  config.vm.provision "shell", path: "provisioning.sh"
end
