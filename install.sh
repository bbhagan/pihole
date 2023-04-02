#! /bin/bash

echo ' '
echo 'Running apt-get update'
echo ' '
sudo apt-get update

echo ' '
echo 'Running apt-get upgrade'
echo ' '
sudo apt-get upgrade -y

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

#echo 'give docker permissions'
#sudo usermod -aG docker $USER

echo ' '
echo 'Cloning repo'
echo ' '
git clone https://github.com/bbhagan/pihole

cd pihole
echo ' '
echo 'Running docker containers'
echo ' '
sudo docker compose up -d

echo ' '
echo 'Sleep 5'
sleep 5
echo 'Get password'
echo "$(sudo docker logs pihole 2>&1 | grep random)"
