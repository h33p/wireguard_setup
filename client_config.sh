#!/usr/bin/env bash

client=$1
ip=$2
dns=$3
public_ip=$4
key=$5

output=($(./client_keys.sh $client))

private=${output[1]}

echo [Interface] > $client.conf
echo PrivateKey = $private >> $client.conf

echo Address = $ip >> $client.conf

echo DNS = $dns >> $client.conf

echo >> $client.conf
echo [Peer] >> $client.conf
echo PublicKey = $key >> $client.conf
echo Endpoint = $public_ip >> $client.conf
echo AllowedIPs = 0.0.0.0/0 >> $client.conf
echo PersistentKeepalive = 21 >> $client.conf
