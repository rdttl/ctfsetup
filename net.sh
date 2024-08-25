#! /bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

# Ensure that both domain name and email address are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "USAGE: $0 domain_name email_address"
  exit 1
fi

# Assign the provided arguments to variables
domain=$1
emailaddr=$2

# Allows stuff through firewall
sudo ufw allow 'OpenSSH'
sudo ufw enable

# Run the Certbot Docker container in standalone mode
docker run -it --rm --name certbot \
    -p 80:80 \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly \
    --standalone \
    -d "$domain" \
    --email "$emailaddr" \
    --agree-tos \
    --no-eff-email

# Copy the certificates over to nginx conf
sudo cp -f /etc/letsencrypt/live/$domain/fullchain.pem "../CTFd/conf/nginx/fullchain.pem"
sudo cp -f /etc/letsencrypt/live/$domain/privkey.pem "../CTFd/conf/nginx/privkey.pem"

# Copy over the config files
cp -f ./http.conf "../CTFd/conf/nginx/http.conf"
cp -f docker-compose.yml "../CTFd/docker-compose.yml"

echo "Configuration finished. Go to \"$user_home/CTFd\", and then \"docker compose up\", with an optional \"-d\" flag for headless mode. DO NOT sudo this."

