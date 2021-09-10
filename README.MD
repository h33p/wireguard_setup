# WireGuard Setup

This script is made for simplifying the set up of a wireguard vpn as well as an unbound DNS server.

It has been modified to allow for clients to add themselves automatically and share public keys through a somewhat unprivileged user.

## Usage

Make sure you have WireGuard installed on your server. Follow [those instructions](https://www.wireguard.com/install/) from the official WireGuard website.

To initiate the VPN and configure the Unbound DNS, use the following command and let you guide :

```
sudo ./server_config.sh init
```

Setup the SSH registration endpoint, and let it guide you through :

```
./endpoint_setup.sh
```

Be wary that it is fairly trivial to escape into interactive shell on the user, so use a secure password.

Every time you need to add a peer to your network, use this command :

```
./client_config.sh peer <interface> <server_ip> <server_port> <endpoint_username> (<dns_servers>)
```

This will attempt to SSH into the remote server, perform key exchange, and create a wireguard interface.
