#!/bin/bash

# Add repos
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo add-apt-repository -y ppa:gns3/ppa
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install gns3, docker, firefox and desktop environment
sudo apt-get -y update && sudo apt -y upgrade
sudo apt-get -y install debconf-utils
sudo debconf-set-selections << EOF
ubridge ubridge/install-setuid  boolean true
wireshark-common        wireshark-common/install-setuid boolean true
EOF
sudo apt-get -y install gns3-gui=2.2\* gns3-server=2.2\* docker-ce docker-ce-cli containerd.io lxqt-core sddm firefox

# Add user to all groups
sudo usermod -aG ubridge vagrant
sudo usermod -aG libvirt vagrant
sudo usermod -aG kvm vagrant
sudo usermod -aG wireshark vagrant
sudo usermod -aG docker vagrant

# New user for GNS3 server service
sudo adduser --disabled-password --gecos '' --home /opt/gns3/ --shell /sbin/nologin gns3
sudo cp gns3.service.systemd /lib/systemd/system/gns3.service
sudo chown root /lib/systemd/system/gns3.service
sudo systemctl enable gns3

# Preparing libraries for Guacamole installation
sudo apt-get -y install build-essential
sudo apt-get -y install libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libssl-dev libwebp-dev

## Configure and build Guacamole server
wget https://dlcdn.apache.org/guacamole/1.3.0/source/guacamole-server-1.3.0.tar.gz
tar -xzf guacamole-server-1.3.0.tar.gz
cd guacamole-server-1.3.0/
./configure --with-systemd-dir=/etc/systemd/system/
make && sudo make install
sudo ldconfig
sudo systemctl enable guacd
cd

# Install Java and Tomcat
sudo apt-get -y install openjdk-11-jdk tomcat9
sudo systemctl enable tomcat9

# Guacamole client
wget https://dlcdn.apache.org/guacamole/1.3.0/binary/guacamole-1.3.0.war
sudo cp guacamole-1.3.0.war /var/lib/tomcat9/webapps/guacamole.war


sudo systemctl reboot