#!/bin/bash
source .env

##################
# Deleting any exiting mattermost zip files
#################
bash ./scripts/utilties.sh echoStatus "Removing exiting zip files and checking if /opt/mattermost exists"

bash $SCRIPTS_UTILITIES echoStatus "Downloading and extracting the Mattermost Upgrade"

## Deleting any old zip files because it'll break some of the further commands
if test -n "$(find $SETUP_DIR -maxdepth 1 -name 'mattermost*.gz' -print -quit)";
then
    rm -r $SETUP_DIR/mattermost*.gz
fi

# Checking if the install dir exists to confirm it should be overwritten or not.
if [ -d $MATTERMOST_INSTALL_DIR ] 
then
    echo "Directory $MATTERMOST_INSTALL_DIR exists." 
    while true; do
        read -p "Do you wish to delete this directory? You have to in order to run this program?   " yn
        case $yn in
            [Yy]* ) rm -rf /opt/mattermost; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done

fi

##################
# Initial Mattermost download
#################
bash $SCRIPTS_UTILITIES echoStatus "Downloading Mattermost $1"

if [[ $1 = 'latest' ]]
then
    wget --content-disposition "https://latest.mattermost.com/mattermost-enterprise-linux" -P $SETUP_DIR
else
    wget "https://releases.mattermost.com/$1/mattermost-$1-linux-amd64.tar.gz" -P $SETUP_DIR
fi


##################
# Unzipping, moving, making dirs. This all happens within the /setup directory
#################
bash $SCRIPTS_UTILITIES echoStatus "Unzipping, moving files, making directories. It's about to get good."
tar -xvzf $SETUP_DIR/mattermost*.gz -C $SETUP_DIR
mv $SETUP_DIR/mattermost /opt
mkdir $MATTERMOST_INSTALL_DIR/data

##################
# Mattermost user setup
#################
bash $SCRIPTS_UTILITIES echoStatus "Making the Mattermost user and setting permissions."
useradd --system --user-group mattermost
chown -R mattermost:mattermost $MATTERMOST_INSTALL_DIR
chmod -R g+w $MATTERMOST_INSTALL_DIR

##################
# Config files.
#################
bash $SCRIPTS_UTILITIES echoStatus "Building the config file. Looks like... $2?"
cp $MATTERMOST_INSTALL_DIR/config/config.json $SETUP_DIR/config.orig.json


if [[ $2 = 'postgres' ]]
then
    jq -s '.[0] * .[1]' $SETUP_DIR/config.orig.json $CONFIG_DATABASE_DIR/postgres.json > $MATTERMOST_INSTALL_DIR/config/config.json
    cp $CONFIG_SERVICEFILES_DIR/postgres-mattermost.service /lib/systemd/system/mattermost.service
else
    jq -s '.[0] * .[1]' $SETUP_DIR/config.orig.json $CONFIG_DATABASE_DIR/mysql.json > $MATTERMOST_INSTALL_DIR/config/config.json
    cp $CONFIG_SERVICEFILES_DIR/mysql-mattermost.service /lib/systemd/system/mattermost.service
fi

##################
# Local mode, this allows mmctl communication without a token. Making life easier
#################
#enabling local mode within the config.json
bash $SCRIPTS_COMMANDS_VARIOUS_MAINTENCE/variousMaintence.sh enableLocalMode

##################
# Finishing the reload.
#################
bash $SCRIPTS_UTILITIES echoStatus "Reloading Mattermost"

systemctl daemon-reload
systemctl start mattermost.service
curl http://localhost:8065

bash $SCRIPTS_UTILITIES echoStatus "All done installing!"
