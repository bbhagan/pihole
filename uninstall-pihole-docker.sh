#! /bin/bash

sudo systemctl stop pihole-docker-compose
sudo systemctl disable pihole-docker-compose
sudo systemctl status pihole-docker-compose

sudo rm -rf /srv/docker/pihole
rm ./pihole_install.log
rm ./uninstall-pihole-docker.sh