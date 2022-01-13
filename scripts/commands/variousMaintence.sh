#!/bin/bash
source .env

enableLocalMode() {
    bash $SCRIPTS_UTILITIES echoStatus "Enabling Local Mode"
    sudo sed -i '/        "EnableLocalMode": false,/c\        "EnableLocalMode": true,' $MATTERMOST_INSTALL_DIR/config/config.json;
}

"$@"

