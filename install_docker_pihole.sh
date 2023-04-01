echo 'apt-get update'
sudo apt-get update
echo 'apt-get upgrade'
sudo apt-get upgrade -y
echo 'install docker'
curl -fsSL https://get.docker.com -o get-docker.sh | bash
echo 'give docker permissions'
sudo usermod -aG docker $USER
curl -fssl https://github.com/