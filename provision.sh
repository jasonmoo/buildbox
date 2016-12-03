#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time
set -e

# update all our packages and add the ones we need
export DEBIAN_FRONTEND=noninteractive
apt-get -qy update

# upgrade, deps and niceties
apt-get -qy dist-upgrade
apt-get -qy install                        \
	git man screen vim curl bzip2          \
	psmisc iftop htop lsof strace
	# apt-transport-https ca-certificates    \
	# linux-image-generic-lts-trusty         \
	# linux-headers-generic-lts-trusty	   \

# echo "answer AUTO_KMODS_ENABLED yes" | tee -a /etc/vmware-tools/locations

# shutdown -r now

# docker install
# apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" > /etc/apt/sources.list.d/docker.list
# apt-get update
# apt-get -qy install docker-engine

