
#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install postgresql postgresql-contrib -y
sudo -u postgres psql -c "CREATE DATABASE mattermost;"
sudo -u postgres psql -c "CREATE USER mmuser WITH PASSWORD 'mmuser-password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mattermost to mmuser;"
sudo systemctl restart postgresql


cd /tmp
echo "Downloading Mattermost..."
wget --content-disposition "https://latest.mattermost.com/mattermost-enterprise-linux"
tar -xvzf mattermost*.gz
mv mattermost /opt
mkdir /opt/mattermost/data
useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost
cp /opt/mattermost/config/config.json config.orig.json
jq -s '.[0] * .[1]' config.orig.json config.json > /opt/mattermost/config/config.json



echo "Setting up the Mattermost service file..."
cp ~/postgres-mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload
systemctl start mattermost.service
curl http://localhost:8065

