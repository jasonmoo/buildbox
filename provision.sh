#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time

# update all our packages and add the ones we need
DEBIAN_FRONTEND=noninteractive
apt-get install -y -q build-essential git mercurial bzr vim curl

# copy in dot files
cd "Home/Google Drive" &&
sudo -u vagrant cp bashrc /home/vagrant/.bashrc &&
sudo -u vagrant cp gitconfig /home/vagrant/.gitconfig

# install go from source (tip)
echo "Pulling and building latest go source tree"
echo -e "[trusted]\nusers = root, vagrant" > /etc/mercurial/hgrc &&
mkdir -p /home/vagrant/go && cd /home/vagrant/go &&
sudo -u vagrant hg clone https://code.google.com/p/go .
# clone is not idempotent so we don't chain off it with a conditional
sudo -u vagrant hg up default &&
cd src/ && ./all.bash &&
go version

echo "Done!"