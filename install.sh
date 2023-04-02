#! /bin/bash

echo 'Cloning repo'
git clone https://github.com/bbhagan/pihole &> ./pihole_install.log

echo 'Running apt-get update'
sudo apt-get update &> ./pihole_install.log

echo ' '
echo 'Running apt-get upgrade'
sudo apt-get upgrade -y &> ./pihole_install.log

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

#echo 'give docker permissions'
#sudo usermod -aG docker $USER

cd pihole
echo ' '
echo 'Running docker containers'
sudo docker compose up -d

#sleep is to make sure everything is totally up before testing
sleep 3

echo ' '
echo 'Test services'
echo "Google IP via cloudflared: $(dig @127.0.0.1 -p 5053 +short google.com)"
echo "Google IP via pihole: $(dig @127.0.0.1 +short google.com)"

echo " "
echo "PASSWORD:"
echo "$(sudo docker logs pihole 2>&1 | grep random)"

cp ../pihole_install.log .
