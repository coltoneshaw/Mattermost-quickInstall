#!/bin/bash

apt update
apt upgrade -y
apt install nodejs jq -y
chmod +x matterhelp

set -a # automatically export all variables
source .env
set +a