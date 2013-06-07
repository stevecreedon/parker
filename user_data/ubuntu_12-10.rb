USER_DATA = <<USER_DATA
#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo apt-get -y update
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git-core
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p392.tar.gz
tar -xvzf ruby-1.9.3-p392.tar.gz
cd ruby-1.9.3-p392/
./configure --prefix=/usr/local
make
sudo make install

cd /tmp

wget http://apt.puppetlabs.com/puppetlabs-release-quantal.deb
sudo dpkg -i puppetlabs-release-quantal.deb
sudo apt-get update -y

sudo apt-get install puppet-common -y

APPLY=/home/ubuntu/puppet-apply

sudo mkfs.ext4 /dev/xvdf
sudo mkdir -m 000 /mnt/data
echo "/dev/xvdf /mnt/data auto noatime 0 0" | sudo tee -a /etc/fstab
sudo mount /mnt/data

echo "#!/usr/bin/env bash" >> $APPLY
echo "rm -rf /tmp/puppet/" >> $APPLY
echo "git clone --recursive git://github.com/fragallia/puppet.git /tmp/puppet" >>  $APPLY
echo "sudo puppet apply /tmp/puppet/manifests/site.pp --modulepath=/tmp/puppet/modules/ -v" >> $APPLY

chmod +x $APPLY
sudo ln -s $APPLY /usr/bin/puppet-apply

DOMAIN=__DOMAIN__
HOSTNAME=__HOSTNAME__

# Set the host name
hostname $HOSTNAME
echo $HOSTNAME > /etc/hostname

# Add fqdn to hosts file
cat<<EOF > /etc/hosts
# This file is automatically genreated by ec2-hostname script
127.0.0.1 localhost
127.0.0.1 $HOSTNAME.$DOMAIN $HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

sudo puppet-apply
USER_DATA