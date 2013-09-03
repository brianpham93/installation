# Upgrade the OS
sudo apt-get dist-upgrade
sudo apt-get update

# Install pip
sudo apt-get install -y --force-yes python-pip

# Install askbot
sudo pip install askbot

# Install mysql
echo mysql-server mysql-server/root_password password password | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | sudo debconf-set-selections
sudo apt-get install -y --force-yes mysql-server

# Create database
mysql -u root -ppassword -e "create database askbot DEFAULT CHARACTER SET UTF8 COLLATE utf8_general_ci"
mysql -u root -ppassword -e "grant all privileges on askbot.* to askbot@localhost identified by 'askbot'"
sudo service mysql restart

# Setup askbot
sudo mkdir ~/qa
cd ~/qa
sudo askbot-setup -n . -e 3 -d askbot -u askbot -p askbot

# Upgrade pip
sudo easy_install -U distribute
sudo apt-get install -y --force-yes mysql-client
sudo apt-get install -y --force-yes libmysqlclient-dev
sudo apt-get install -y --force-yes python-dev
sudo pip install mysql-python

# Downgrade Django
sudo pip install Django==1.4.0
# Initialize db
sudo python manage.py syncdb --all --noinput
sudo python manage.py migrate askbot --fake
sudo python manage.py migrate django_authopenid --fake

# Deploy on webserver
sudo python manage.py collectstatic --noinput
sudo chown -R www-data:www-data ~/qa
sudo chmod -R g+w ~/qa/askbot/upfiles
sudo chmod -R g+w ~/qa/log

# Install apache
sudo apt-get install -y --force-yes apache2 libapache2-mod-wsgi

# Config files
sudo wget "https://raw.github.com/nhimhobao/askbot-installation-scripts/master/qa" -P /etc/apache2/sites-available/

# Remove default configuration files
sudo rm /etc/apache2/sites-available/default 
sudo rm /etc/apache2/sites-available/default-ssl    
sudo rm /etc/apache2/sites-enabled/000-default
sudo ln -s /etc/apache2/sites-available/qa /etc/apache2/sites-enabled/qa

# Restart apache one last time
sudo services apache2 restart

