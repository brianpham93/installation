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

# Install mysql server and plugin for python
sudo apt-get -y --force-yes install -y python-mysqldb mysql-server
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
sudo service mysql restart


# Ininitlize databases
mysql -u root -ppassword -e "CREATE DATABASE nova"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -ppassword -e "CREATE DATABASE cinder"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -ppassword -e "CREATE DATABASE glance"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -ppassword -e "CREATE DATABASE keystone"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -ppassword -e "CREATE DATABASE quantum"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'localhost' IDENTIFIED BY 'password'"

echo "mysql -u root -ppassword -e 'GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.9' IDENTIFIED BY 'password''" > todo
echo "mysql -u root -ppassword -e 'GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.11' IDENTIFIED BY 'password'" > todo

mysql -u root -ppassword -e "FLUSH PRIVILEGES"

# RabitMQ
sudo apt-get -y --force-yes install -y rabbitmq-server
sudo rabbitmqctl change_password guest password

# Install keystone
apt-get install -y keystone python-keystone python-keystoneclient
echo "Edit /etc/keystone/keystone.conf" > todo

# Seed data
sudo chmod +x ./bash.sh
./bash.sh