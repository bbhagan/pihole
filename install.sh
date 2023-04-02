echo 'apt-get update'
sudo apt-get update

echo 'apt-get upgrade'
sudo apt-get upgrade -y

#echo 'install docker'
#curl -fsSL https://get.docker.com -o get-docker.sh | bash

#echo 'give docker permissions'
#sudo usermod -aG docker $USER

echo 'cloning repo'
git clone https://github.com/bbhagan/pihole

cd pihole
echo 'running docker containers'
sudo docker compose up -d

echo ' '
echo 'pihole password'
echo sudo docker logs pihole 2>&1 | grep random