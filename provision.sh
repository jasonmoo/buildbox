#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time

# update all our packages and add the ones we need
DEBIAN_FRONTEND=noninteractive
apt-get install -y -q build-essential git mercurial bzr vim curl

# copy in dot files
cd "Home/Google Drive" &&
sudo -u vagrant cp bashrc /home/vagrant/.bashrc &&
sudo -u vagrant cp gitconfig /home/vagrant/.gitconfig

echo "Adding root, vagrant as trusted users in the mercurial space"
echo -e "[trusted]\nusers = root, vagrant" > /etc/mercurial/hgrc

# install go from source (tip)
echo "Pulling latest go source tree..."
# ensure we've got a repo to build
[ -d /home/vagrant/go ] || hg clone -U https://code.google.com/p/go /home/vagrant/go
cd /home/vagrant/go && hg pull && hg up default && hg summary
echo "Building... this will take a while"
cd src/ && ./all.bash &&
echo "Symlinking binaries to /usr/local/bin for global access"
ln -sf /home/vagrant/go/bin/* /usr/local/bin &&
go version

echo "Done!"