#!/bin/bash

priv_username=$1

if [[ -z $priv_username ]]; then
    echo "Enter privileged username for registration:"
    read priv_username
fi

sudo cp wg-registration@.service /etc/systemd/system/wg-registration@.service
sudo cp wireguard_registration_listener.sh /usr/local/bin/
sudo cp server_config.sh /usr/local/bin/
sudo systemctl daemon-reload
sudo systemctl start wg-registration@$priv_username
