#! /bin/bash

GREEN="\033[32m"
NORMAL="\033[0;39m"
BOLD="\033[0;1m"
INSTALL_INIT_PATH=$(pwd)
INSTALL_LOG=$INSTALL_INIT_PATH/pihole_install.log
echo "Install log: $INSTALL_LOG"

test_services() {
echo " "
echo "Test services"
echo "Google IP via cloudflared: $(dig @127.0.0.1 -p 5053 +short google.com)"
echo "Google IP via pihole: $(dig @127.0.0.1 +short google.com)"
}

echo " "
echo "Adding hard DNS Servers"
sudo nmcli connection modify "Wired connection 1" ipv4.dns "1.1.1.1,8.8.8.8,9.9.9.9"
sleep 1
echo "Local DNS Servers:"
nmcli connection show "Wired connection 1" | grep "ipv4.dns:"

echo " "
echo "Running apt-get update"
sudo apt-get update &>> $INSTALL_LOG

echo " "
echo "Running apt-get autoremove"
sudo apt-get autoremove -y &>> $INSTALL_LOG

echo " "
echo "Running apt-get dist-upgrade"
sudo apt-get dist-upgrade -y &>> $INSTALL_LOG

echo " "
if [ -e "/usr/bin/dig" ]
then
    echo "Not installing dnsutils"
else
    echo "Install dnsutils"
    sudo apt-get install dnsutils -y &>> $INSTALL_LOG
fi

echo " "
if [ -e "/usr/bin/docker" ]
then
    echo "Not installing docker"
else
    echo "Install docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    bash get-docker.sh &>> $INSTALL_LOG
fi

echo " "
echo "Cloning repo, copying, moving files"
sudo git clone https://github.com/bbhagan/pihole /srv/docker/pihole &>> $INSTALL_LOG
sudo cp /srv/docker/pihole/pihole-docker-compose.service /etc/systemd/system/pihole-docker-compose.service
sudo cp /srv/docker/pihole/piholerfkillall.sh /usr/local/bin/piholerfkillall.sh
sudo cp /srv/docker/pihole/rfkill.service /etc/systemd/system/rfkill.service
cp /srv/docker/pihole/uninstall-pihole-docker.sh .

echo " "
echo "RFKill service and starting"
echo "Before:"
rfkill
sudo systemctl enable rfkill &>> $INSTALL_LOG
sudo systemctl start rfkill &>> $INSTALL_LOG
sleep 3 #sleep is to make sure everything is totally up before testing
echo "After:"
rfkill

echo " "
echo "Booting docker containers"
cd /srv/docker/pihole
sudo docker compose up -d
sleep 3 #sleep is to make sure everything is totally up before testing
test_services
PASSWORD=$(sudo docker logs pihole 2>&1 | grep random)
sudo docker compose down

echo " "
echo "Making a service and starting"
sudo systemctl enable pihole-docker-compose &>> $INSTALL_LOG
sudo systemctl start pihole-docker-compose &>> $INSTALL_LOG
sleep 3 #sleep is to make sure everything is totally up before testing
sudo systemctl status pihole-docker-compose &>> $INSTALL_LOG
sudo systemctl status pihole-docker-compose

test_services

echo " "
echo -e "Pi-hole UI password:$BOLD $GREEN $PASSWORD $NORMAL"
echo "Pi-hole UI: http://127.0.0.1/admin"



