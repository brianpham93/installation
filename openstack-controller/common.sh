# Update kernel
sudo apt-get -y --force-yes dist-upgrade
sudo apt-get -y --force-yes update

# Install keyring
sudo apt-get -y --force-yes install ubuntu-cloud-keyring

# Add repository
sudo echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main" > /etc/apt/sources.list.d/cloud-archive.list

sudo apt-get -y --force-yes update 
sudo apt-get -y --force-yes upgrade

#
sudo echo "deb http://archive.gplhost.com/debian grizzly main" > /etc/apt/sources.list.d/grizzly.list
sudo echo "deb http://archive.gplhost.com/debian grizzly-backports main" >/etc/apt/sources.list.d/grizzly.list

sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes install gplhost-archive-keyring
sudo apt-get -y --force-yes upgrade


# Install 
sudo apt-get -y --force-yes install -y ntp