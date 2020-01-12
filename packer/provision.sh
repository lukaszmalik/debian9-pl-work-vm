# ____
# | __ )  __ _ ___  ___
# |  _ \ / _` / __|/ _ \
# | |_) | (_| \__ \  __/
# |____/ \__,_|___/\___|

export DEBIAN_FRONTEND=noninteractive

# Update the box
apt-get -qqy update
apt-get -qqy upgrade
apt-get -qqy install linux-headers-$(uname -r) build-essential

apt-get -qqy install zlib1g-dev libssl-dev libreadline-gplv2-dev \
  curl wget vim mc screen zsh unzip pbzip2 lsof htop iotop dstat \
  telnet tcpdump make jq gnupg git build-essential apt-transport-https aptitude \
  python python-apt python-dev python-jinja2 python-zmq python-tornado \
  ruby openjdk-8-jre-headless pkg-config libexpat1-dev avahi-daemon

# Remove unneeded items
apt-get -qy purge exim4 exim4-base

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Disable barriers on root filesystem
sed -i 's/noatime,errors/nobarrier,noatime,nodiratime,errors/' /etc/fstab

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub

# __     __                          _
# \ \   / /_ _  __ _ _ __ __ _ _ __ | |_
#  \ \ / / _` |/ _` | '__/ _` | '_ \| __|
#   \ V / (_| | (_| | | | (_| | | | | |_
#    \_/ \__,_|\__, |_|  \__,_|_| |_|\__|
#              |___/

# Set up Vagrant.
date > /etc/vagrant_box_build_time

# Create the user vagrant with password vagrant
useradd -G sudo -p $(perl -e'print crypt("vagrant", "vagrant")') -m -s /bin/bash -N vagrant

# Install vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
curl -Lo /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /var/run/motd

# Install NFS client
apt-get -y install nfs-common


# __     ___      _               _ ____
# \ \   / (_)_ __| |_ _   _  __ _| | __ )  _____  __
#  \ \ / /| | '__| __| | | |/ _` | |  _ \ / _ \ \/ /
#   \ V / | | |  | |_| |_| | (_| | | |_) | (_) >  <
#    \_/  |_|_|   \__|\__,_|\__,_|_|____/ \___/_/\_\

if test -f .vbox_version ; then
  # The netboot installs the VirtualBox support (old) so we have to remove it
  if test -f /etc/init.d/virtualbox-ose-guest-utils ; then
    /etc/init.d/virtualbox-ose-guest-utils stop
  fi

  rmmod vboxguest
  apt-get -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils

  # Install dkms for dynamic compiles
  # If libdbus is not installed, virtualbox will not autostart
  apt-get -y install --no-install-recommends libdbus-1-3 dkms

  # Install the VirtualBox guest additions
  mount -o loop VBoxGuestAdditions.iso /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm -f VBoxGuestAdditions.iso

  # Start the newly build driver
  service vboxadd start
  echo Finished
fi


#   ____ _
#  / ___| | ___  __ _ _ __    _   _ _ __
# | |   | |/ _ \/ _` | '_ \  | | | | '_ \
# | |___| |  __/ (_| | | | | | |_| | |_) |
#  \____|_|\___|\__,_|_| |_|  \__,_| .__/
#                                  |_|

# Clean up
apt-get -y autoremove
apt-get -y clean

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up logs"
rm -f /var/log/auth.log /var/log/daemon.log /var/log/messages /var/log/syslog

# Make sure Udev doesn't block our network
echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces


# __  __ _       _           _
# |  \/  (_)_ __ (_)_ __ ___ (_)_______
# | |\/| | | '_ \| | '_ ` _ \| |_  / _ \
# | |  | | | | | | | | | | | | |/ /  __/
# |_|  |_|_|_| |_|_|_| |_| |_|_/___\___|

echo "Fill with 0 the swap partition to reduce box size"
readonly swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
readonly swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
/sbin/swapoff "$swappart"
dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed"
/sbin/mkswap -U "$swapuuid" "$swappart"

echo "Fill filesystem with 0 to reduce box size"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync


