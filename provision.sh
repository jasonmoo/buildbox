#!/bin/bash

## This script is run from /home/vagrant, within the VM, as root, at provision time
set -e

# update all our packages and add the ones we need
export DEBIAN_FRONTEND=noninteractive
apt-get -qy update

# upgrade, deps and niceties
apt-get -qy  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -qy install                  \
	build-essential clang pkg-config \
	git mercurial bzr man            \
	screen rsync vim curl bzip2      \
	psmisc iftop htop lsof strace    \
    lxc lxc-dev                      \
    software-properties-common python-software-properties \
    linux-image-3.16.0-25-generic    \
    linux-headers-3.16.0-25-generic  \
    linux-image-extra-3.16.0-25-generic

# enable aufs/overlayfs modules on boot
grep "aufs"      /etc/modules || echo "aufs" >> /etc/modules
grep "overlayfs" /etc/modules || echo "overlayfs" >> /etc/modules

# enable cgroup memory/swap for lxc
sed -i'' 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub

# forcing auto rebuild of kernel modules on reboot, fixes HGFS missing module when upgrading kernel
grep "answer AUTO_KMODS_ENABLED yes" /etc/vmware-tools/locations || echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations


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
sudo -u vagrant mkdir /home/vagrant/go
sudo -u vagrant ln -s /home/vagrant/Home/go/src /home/vagrant/go/src

# copy in dot files
cd "/home/vagrant/Home/Google Drive/Dropbox/Google Drive"
sudo -u vagrant cp bashrc /home/vagrant/.bashrc
sudo -u vagrant cp gitconfig /home/vagrant/.gitconfig

echo "Setting PATH, GOROOT, GOPATH"
sudo -u vagrant cat <<EOF > /home/vagrant/.bash_extras
export PATH=\$PATH:/usr/local/go/bin:/home/vagrant/go/bin
export GOROOT=/usr/local/go
export GOPATH=/home/vagrant/go
EOF

