#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time
set -e

# update all our packages and add the ones we need
export DEBIAN_FRONTEND=noninteractive
apt-get -qy update

# upgrade, deps and niceties
apt-get -qy  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -qy install                  \
	linux-image-generic-lts-raring   \
	linux-headers-generic-lts-raring \
	apt-transport-https apparmor     \
	build-essential clang pkg-config \
	git mercurial bzr man            \
	screen rsync vim curl bzip2      \
	psmisc iftop htop lsof strace

# docker install
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo "deb https://get.docker.com/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get -qy install lxc-docker

# copy in dot files
cd "Home/Google Drive/Dropbox/Google Drive"
sudo -u vagrant cp bashrc /home/vagrant/.bashrc
sudo -u vagrant cp gitconfig /home/vagrant/.gitconfig

echo "Adding root, vagrant as trusted users in the mercurial space"
echo -e "[trusted]\nusers = root, vagrant" > /etc/mercurial/hgrc

# install go from source (tip)
echo "Pulling latest go source tree..."
# ensure we've got a repo to build
[ -d /usr/local/go ] || hg clone -U https://code.google.com/p/go /usr/local/go
cd /usr/local/go && hg pull && hg up release && hg summary
echo "Building... this will take a while"
cd src/ && ./all.bash

# symlink the gopath's src dir to our mac
# allows separate pkg/bin dirs
mkdir /home/vagrant/go && ln -s /home/vagrant/Home/go/src /home/vagrant/go/src

echo "Setting PATH, GOROOT, GOPATH"
cat <<EOF > /home/vagrant/.bash_extras
export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin
export GOROOT=/usr/local/go
export GOPATH=/home/vagrant/go
EOF

# reclaim some dirs/files
chown vagrant:vagrant /home/vagrant/go /home/vagrant/.bash_extras

# forcing auto rebuild of kernel modules on reboot, fixes HGFS missing module when upgrading kernel
echo "answer AUTO_KMODS_ENABLED yes" | tee -a /etc/vmware-tools/locations

# enable cgroup swap management
echo 'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' | tee -a /etc/default/grubj
update-grub
