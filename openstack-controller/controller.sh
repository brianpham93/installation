# Install mysql server and plugin for python
echo mysql-server mysql-server/root_password password password | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | sudo debconf-set-selections

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

echo "GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.9" > todo
echo "GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.11" > todo

mysql -u root -ppassword -e "FLUSH PRIVILEGES"

# RabitMQ
sudo apt-get -y --force-yes install -y rabbitmq-server
sudo rabbitmqctl change_password guest password

# Install keystone
sudo apt-get install -y keystone python-keystone python-keystoneclient
echo "Edit /etc/keystone/keystone.conf" > todo