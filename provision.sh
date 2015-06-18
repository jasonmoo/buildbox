#!/bin/bash -ex

## This script is run from /home/vagrant, within the VM, as root, at provision time

# update all our packages and add the ones we need
export DEBIAN_FRONTEND=noninteractive
apt-get -qy update

# upgrade, deps and niceties
apt-get -qy  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -qy install                     \
	build-essential clang pkg-config    \
	autoconf yum                        \
	git mercurial bzr man               \
	screen rsync vim curl bzip2         \
	psmisc iftop htop lsof strace       \
    software-properties-common          \
    python-software-properties          \
    linux-image-3.16.0-29-generic       \
    linux-headers-3.16.0-29-generic     \
    linux-image-extra-3.16.0-29-generic \
    lxc lxc-dev

# # source install if you wanna
# #
# rm -rf /usr/local/lxc
# mkdir -p /usr/local/lxc
# cd /usr/local/lxc
# chown vagrant:vagrant -R .
# git clone https://github.com/jasonmoo/lxc.git .
# ./autogen.sh
# ./configure
# make
# make install
# # hack to fix linking issue
# mv /usr/local/lib/liblxc* /usr/lib/x86_64-linux-gnu

# enable aufs/overlayfs modules on boot
grep "aufs"      /etc/modules || echo "aufs" >> /etc/modules
grep "overlayfs" /etc/modules || echo "overlayfs" >> /etc/modules

# enable cgroup memory/swap for lxc
sed -i'' 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub

# forcing auto rebuild of kernel modules on reboot, fixes HGFS missing module when upgrading kernel
grep "answer AUTO_KMODS_ENABLED yes" /etc/vmware-tools/locations || echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations


# install go from source (tip)
# echo "Pulling latest go source tree..."
# [ -d /usr/local/go ] || git clone https://github.com/golang/go.git /usr/local/go
# chown vagrant:vagrant -R /usr/local/go
# echo "Building... this will take a while"
# cd /usr/local/go/src && ./all.bash

# symlink the gopath's src dir to our mac
# allows separate pkg/bin dirs
# sudo -u vagrant mkdir -p /home/vagrant/go
# sudo -u vagrant ln -s /home/vagrant/Home/go/src /home/vagrant/go/src

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

