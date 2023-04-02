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

#sleep is to make sure everything is totally up before testing
sleep 3

echo ' '
echo 'Test services'
echo 'Google IP via cloudflared: $(dig @127.0.0.1 -p 5053 +short google.com)'
echo 'Google IP via pihole: $(dig @127.0.0.1 +short google.com)'

echo ' '
echo 'PASSWORD:'
echo "$(sudo docker logs pihole 2>&1 | grep random)"
