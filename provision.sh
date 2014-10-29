#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time

# update all our packages and add the ones we need
DEBIAN_FRONTEND=noninteractive
apt-get update &&
apt-get dist-upgrade &&
apt-get install -y -q \
	build-essential \
	git mercurial bzr \
	screen rsync vim curl bzip2 \
	psmisc iftop htop lsof strace

# copy in dot files
cd "Home/Google Drive/Dropbox/Google Drive" &&
sudo -u vagrant cp bashrc /home/vagrant/.bashrc &&
sudo -u vagrant cp gitconfig /home/vagrant/.gitconfig

echo "Adding root, vagrant as trusted users in the mercurial space"
echo -e "[trusted]\nusers = root, vagrant" > /etc/mercurial/hgrc

# install go from source (tip)
echo "Pulling latest go source tree..."
# ensure we've got a repo to build
[ -d /usr/local/go ] || hg clone -U https://code.google.com/p/go /usr/local/go
cd /home/vagrant/go && hg pull && hg up release && hg summary
echo "Building... this will take a while"
cd src/ && ./all.bash &&
echo "Symlinking binaries to /usr/local/bin for global access"
ln -sf /usr/local/go/bin/* /usr/local/bin &&
go version

echo "Done!"