# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "forwarded_port", guest: 80, host: 8000
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 3389, host: 3389
  config.vm.provision "file", source: "gns3.service.systemd", destination: "$HOME/gns3.service.systemd"
  config.vm.provision "file", source: "gns3_server.conf", destination: "$HOME/.config/GNS3/2.2/gns3_server.conf"
  config.vm.provision "file", source: "nginx_guacamole.conf", destination: "$HOME/nginx_guacamole.conf"
  config.vm.provision "file", source: "server.xml", destination: "$HOME/server.xml"
  config.vm.provision "file", source: "user-mapping.xml", destination: "$HOME/user-mapping.xml"
  config.vm.provision "file", source: "GNS3.desktop", destination: "$HOME/GNS3.desktop"
  config.vm.provision "file", source: "x11vnc.service", destination: "$HOME/x11vnc.service"
  config.vm.provision "shell", path: "provisioning.sh"
end
