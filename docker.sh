#! /bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

sudo apt update -y && sudo apt upgrade -y
sudo apt install ca-certificates curl gnupg lsb-release

# Docker GPG key, setup of the stable Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installs docker components that we need
sudo apt update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adds the current user to docker group, then requires a logout to apply
sudo groupadd docker
sudo usermod -aG docker $USER
clear
echo "Rebooting... Please reconnect in a bit, and then install CTFd"
sleep 3
sudo reboot

