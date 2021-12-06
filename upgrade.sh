#!/bin/bash
cd /tmp
#wget --content-disposition "https://latest.mattermost.com/mattermost-enterprise-linux"
wget "https://releases.mattermost.com/$1/mattermost-$1-linux-amd64.tar.gz"

tar -xf mattermost*.gz --transform='s,^[^/]\+,\0-upgrade,'


echo "Stopping Mattermost..."
systemctl stop mattermost
cd /opt

echo "Making a backup..."
cp -ra mattermost/ mattermost-back-$(date +'%F-%H-%M')/

echo "Deleting old files..."
find mattermost/ mattermost/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path mattermost/client -o -path mattermost/client/plugins -o -path mattermost/config -o -path mattermost/logs -o -path mattermost/plugins -o -path mattermost/data \) -prune \) | sort | sudo xargs rm -r

echo "Moving around upgrade files"
cp -an /tmp/mattermost-upgrade/. mattermost/
rm -r /tmp/mattermost-upgrade/

echo "Changing ownership of the opt/mattermost dir..."
chown -R mattermost:mattermost /opt/mattermost

echo "Starting Mattermost..."
systemctl start mattermost

echo "Do you want to delete the upgrade zip? Say yes."
rm -i /tmp/mattermost*.gz