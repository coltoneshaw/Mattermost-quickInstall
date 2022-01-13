#!/bin/bash
source .env

bash $SCRIPTS_UTILITIES echoStatus "Setting up NGINX"
apt install nginx -y
cp configs/nginx-mattermost.conf /etc/nginx/sites-available/nginx-mattermost.conf
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/nginx-mattermost.conf /etc/nginx/sites-enabled/nginx-mattermost
systemctl restart nginx
