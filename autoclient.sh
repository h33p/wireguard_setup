#!/usr/bin/env bash

client=$1
public_ip=$2
server_port=$3
ssh_user=$4
dns=$5
pubkey=($(./client_keys.sh $client))
pubkey=${pubkey[0]}

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

./client_config.sh $client $ip $dns $public_ip:${server_port} $pubkey
