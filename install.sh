#! /bin/bash

INSTALL_INIT_PATH=$(pwd)
echo "INSTALL_PATH: $INSTALL_INIT_PATH"
INSTALL_LOG=$INSTALL_INIT_PATH/pihole_install.log
echo "INSTALL_LOG: $INSTALL_LOG"

test_services() {
echo " "
echo "Test services"
echo "Google IP via cloudflared: $(dig @127.0.0.1 -p 5053 +short google.com)"
echo "Google IP via pihole: $(dig @127.0.0.1 +short google.com)"
}

echo " "
echo "Running apt-get update"
sudo apt-get update &>> $INSTALL_LOG

echo " "
echo "Running apt-get upgrade"
sudo apt-get upgrade -y &>> $INSTALL_LOG

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

echo ' '
echo 'Cloning repo'
sudo git clone https://github.com/bbhagan/pihole /srv/docker/pihole &>> $INSTALL_LOG
sudo cp /srv/docker/pihole/pihole-docker-compose.service /etc/systemd/system/pihole-docker-compose.service
cp /srv/docker/pihole/uninstall-pihole-docker.sh .

echo ' '
echo 'Booting docker containers'
cd /srv/docker/pihole
sudo docker compose up -d
test_services
sudo docker compose down

echo " "
echo "Making a service and starting"
sudo systemctl enable pihole-docker-compose &>> $INSTALL_LOG
sudo systemctl start pihole-docker-compose &>> $INSTALL_LOG
sudo systemctl status pihole-docker-compose &>> $INSTALL_LOG

#sleep is to make sure everything is totally up before testing
sleep 5

test_services

echo " "
echo "PASSWORD:"
echo "$(sudo docker logs pihole 2>&1 | grep random)"



