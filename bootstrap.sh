#!/bin/bash

echo -e "\nInstalling Teamspeak 3 server...\n"
# http://forum.teamspeak.com/showthread.php/68827-Failed-to-register-local-accounting-service
mount -t tmpfs tmpfs /dev/shm

wget -N -q http://dl.4players.de/ts/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
tar xzf teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
(cd teamspeak3-server_linux-amd64/; ./ts3server_startscript.sh stop;./ts3server_startscript.sh start serveradmin_password=travis_test)

echo -e "\nInstalling Ruby...\n"
apt-get install software-properties-common -y
apt-add-repository ppa:brightbox/ruby-ng -y
apt-get update -y
apt-get install ruby2.3 ruby2.3-dev ruby-switch -y
ruby-switch --set ruby2.3

echo -e "\nInstalling gems...\n"
gem install bundler
su - vagrant -c 'cd /vagrant/; bundle install'
