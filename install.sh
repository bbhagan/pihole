#! /bin/bash

echo ' '
echo 'Running apt-get update'
sudo apt-get update &>> ./pihole_install.log

echo ' '
echo 'Running apt-get upgrade'
sudo apt-get upgrade -y &>> ./pihole_install.log

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

#echo 'give docker permissions'
#sudo usermod -aG docker $USER

echo ' '
echo 'Cloning repo'
sudo git clone https://github.com/bbhagan/pihole /srv/docker/pihole &>> ./pihole_install.log
sudo cp /srv/docker/pihole/pihole-docker-compose.service /etc/systemd/system/pihole-docker-compose.service
cp /srv/docker/pihole/uninstall-pihole-docker.sh .

echo ' '
echo 'Running docker containers'

sudo systemctl enable pihole-docker-compose &>> ./pihole_install.log
sudo systemctl start pihole-docker-compose &>> ./pihole_install.log
sudo systemctl status pihole-docker-compose &>> ./pihole_install.log

#sleep is to make sure everything is totally up before testing
sleep 5

echo ' '
echo 'Test services'
echo "Google IP via cloudflared: $(dig @127.0.0.1 -p 5053 +short google.com)"
echo "Google IP via pihole: $(dig @127.0.0.1 +short google.com)"

echo " "
echo "PASSWORD:"
echo "$(sudo docker logs pihole 2>&1 | grep random)"

