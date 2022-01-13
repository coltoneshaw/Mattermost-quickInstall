#!/bin/bash
source .env

if [[ $1 = 'postgres' ]]
then
    # apt install postgresql postgresql-contrib -y
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    apt-get update
    apt-get -y install postgresql-13 postgresql-client-13
    sudo -u postgres psql -c "CREATE DATABASE mattermost;"
    sudo -u postgres psql -c "CREATE USER mmuser WITH PASSWORD 'mmuser-password';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mattermost to mmuser;"
    systemctl restart postgresql   
fi