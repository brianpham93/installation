sudo apt-get -y --force-yes install phpmyadmin
sudo echo "Include /etc/phpmyadmin/apache.conf" > /etc/apache2/apache2.conf
sudo service apache2 restart
