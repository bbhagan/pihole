#! /bin/bash

echo ' '
echo 'apt-get update'
echo ' '
sudo apt-get update

echo ' '
echo 'apt-get upgrade'
echo ' '
sudo apt-get upgrade -y

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

#echo 'give docker permissions'
#sudo usermod -aG docker $USER

echo ' '
echo 'cloning repo'
echo ' '
git clone https://github.com/bbhagan/pihole

cd pihole
echo ' '
echo 'running docker containers'
echo ' '
sudo docker compose up -d

echo ' '
sudo docker logs pihole 2>&1 | grep random >> pihole_password.txt
