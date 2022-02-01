#!/bin/bash
source .env


bash $SCRIPTS_UTILITIES echoStatus "Downloading and extracting the Mattermost Upgrade"
if [[ $1 = 'latest' ]]
then
    wget --content-disposition "https://latest.mattermost.com/mattermost-enterprise-linux" -P $SETUP_DIR
else
    wget "https://releases.mattermost.com/$1/mattermost-$1-linux-amd64.tar.gz" -P $SETUP_DIR
fi

tar -xf $SETUP_DIR/mattermost*.gz --transform='s,^[^/]\+,\0-upgrade,' -C $SETUP_DIR
echo "Done..."


bash $SCRIPTS_UTILITIES echoStatus "Stopping Mattermost..."
systemctl stop mattermost
echo "Done..."

bash $SCRIPTS_UTILITIES echoStatus "Making a backup..."
cp -ra $MATTERMOST_INSTALL_DIR /opt/mattermost-back-$(date +'%F-%H-%M')/
echo "Done..."

bash $SCRIPTS_UTILITIES echoStatus "Deleting old files and moving things around..."
find $MATTERMOST_INSTALL_DIR/ $MATTERMOST_INSTALL_DIR/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path $MATTERMOST_INSTALL_DIR/client -o -path $MATTERMOST_INSTALL_DIR/client/plugins -path $MATTERMOST_INSTALL_DIR/client -o -path $MATTERMOST_INSTALL_DIR/client/emoji -o -path $MATTERMOST_INSTALL_DIR/config -o -path $MATTERMOST_INSTALL_DIR/logs -o -path $MATTERMOST_INSTALL_DIR/plugins -o -path $MATTERMOST_INSTALL_DIR/data \) -prune \) | sort | sudo xargs rm -r
cp -an $SETUP_DIR/mattermost-upgrade/. $MATTERMOST_INSTALL_DIR/
rm -r $SETUP_DIR/mattermost-upgrade/
rm -r $SETUP_DIR/mattermost*.gz
chown -R mattermost:mattermost $MATTERMOST_INSTALL_DIR

#enabling local mode within the config.json
bash $SCRIPTS_COMMANDS_VARIOUS_MAINTENCE enableLocalMode

echo "Done..."


bash $SCRIPTS_UTILITIES echoStatus "Starting Mattermost..."
systemctl start mattermost
echo "Done..."

bash $SCRIPTS_UTILITIES echoStatus "Finished. Enjoy!"