# GNS3-VM

## Credentials

There are 2 options and for both you need to open ports on your cloud provider's firewall!

### HTTP (Guacamole) - preferred

Endpoint: `IP of your VM instance`

Ports: `80` and `443`

Username: `fri-rk`

Password: `g^Z8g4Y#bU4L`

I recommend using Firefox as Chrome doesn't like self-signed certs :)

### RDP (in case Guacamole doesn't work)

Hostname: `IP of your VM instance`

Port: `3389`

Username: `ubuntu`

Password: `g^Z8g4Y#bU4L`

## Vagrant

When deciding which OS to use I took into consideration what I'm comfortable with, stability and immutability, long-term support and guides from GNS3 documentation. Ultimately my decision was Ubuntu 20.04 which has Long-Term Support (LTS) so packages won't change much and will get security updates...there's also a guide in GNS3 documentation that shows how to install on Ubuntu.
My second option was Fedora which I use on a daily basis and has great support for open-source packages out-of-the box which includes GNS3 whereas Ubuntu needs a PPA to support it, but Fedora is not stable enough since it releases new version every 6 months.

First I started working on Vagrant because I'm more comfortable with it. As a base image I chose `generic/ubuntu2004` since it supports more providers than official `ubuntu/focal64`, but the downside is the image is 3x bigger than official one.

For connection to the VM, I decided to use Apache Guacamole for its simplicity and ease of use and because it uses a HTML5 viewer so users don't need to install any special software.

I had to decide between VNC and RDP for underlying protocol of Guacamole. Even though RDP is a proprietary protocol I ended up using it because according my research should be aware of what it transmits for example instead of just capturing an image of the whole screen like VNC, it transmits information about objects (button, color, position...). It also supports bidirectional clipboard and other things we don't need like audio, microphone...

I created a provisioning script that installs everything needed to run GNS3:

- Add repos for GNS3 and Docker
- Install GNS3, Docker and Firefox
- Add user to necessary groups
- Prepare gns3-server to work as a daemon and run gns3-gui on startup
- Configure and build Apache Guacamole
- Install Tomcat and Java for Guacamole client
- Install and configure nginx reverse proxy with SSL
- Install XRDP server

The configuration files are included in the repo and are transferred to the VM.

Systemd init script for GNS3 server was retrived from the offical (GNS3 repo)[https://github.com/GNS3/gns3-server/blob/master/init/gns3.service.systemd]

When setting up nginx config I used this neat [tool](https://ssl-config.mozilla.org/#server=nginx&version=1.17.0&config=intermediate&openssl=1.1.1&hsts=false&ocsp=false&guideline=5.6) to generate sane defaults.

## Cloud-init

Cloud-init was pretty straightforward to port from Vagrant. It simplifies things like adding repos and installing packages, adding users and groups, writing files.
But after I've written cloud-config I had a hard time debugging it and trying to figure out what went wrong.
The issue I spent the most time on was RDP not connecting to the xorg server. It turns out the problem was with write_files. One entry in write_files had a path in the home directory of ubuntu user and because this was executed before the user ubuntu was even created, this meant the root user created all directories of the path and took ownership of the home directory. That somehow caused RDP to not work...I guess there was some configs in the home directory but I'm not sure.

## Guacamole issues

In one of the iterations I had Guacamole working perfectly and could connect to the VM but somewhere along the way something broke and that wasn't the case anymore.
Error in the logs was: RDP server closed/refused connection: Security negotiation failed (wrong security type?)
I tried setting 'security' to 'any' and 'ignore-cert' to 'yes' but that didn't help.

## Security

As this was primarily designed to be accessed with Guacamole I set a random generated password and although the password is published in this repo I think for the purpose of running GNS3 it's acceptable risk. I wanted to make it generate a random password for each instance but that turned out to be more complicated than I thought.
