#!/usr/bin/env bash

client=$1
public_ip=$2
server_port=$3
ssh_user=$4
dns=$5

### Key setup

KEY_PATH=$HOME/.config/wireguard_setup/client

if [[ ! -d $KEY_PATH ]]; then
    mkdir -p $KEY_PATH
    cd $KEY_PATH
    umask 077
fi

if [[ ! -f $KEY_PATH/privatekey_$client ]]; then
    wg genkey | tee $KEY_PATH/privatekey_$client | wg pubkey > $KEY_PATH/publickey_$client
fi

pubkey=$(cat $KEY_PATH/publickey_$client)
privkey=$(cat $KEY_PATH/privatekey_$client)

### Key exchange

echo "Client: $client"
echo "Public IP: $public_ip:$server_port"
echo "DNS: $dns"
echo "Pubkey: $pubkey"

echo "Enter password for remote privileged user:"
read -s pass_su

output=$({ echo $pass_su; echo $pubkey; } | ssh ${ssh_user}@${public_ip})

lines=($output)

ip=${lines[0]}
pubkey=${lines[1]}

if [[ -z $pubkey ]]; then
    echo "Could not retrieve IP and server's public key!"
    exit
fi

echo $ip
echo $pubkey

### Local config

echo [Interface] > $client.conf
echo PrivateKey = $privkey >> $client.conf

echo Address = $ip >> $client.conf

if [[ ! -z $dns ]]; then
	echo DNS = $dns >> $client.conf
fi

echo >> $client.conf
echo [Peer] >> $client.conf
echo PublicKey = $pubkey >> $client.conf
echo Endpoint = $public_ip:${server_port} >> $client.conf
echo AllowedIPs = 0.0.0.0/0 >> $client.conf
echo PersistentKeepalive = 21 >> $client.conf

