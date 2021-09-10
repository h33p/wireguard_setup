#!/usr/bin/env bash

echo "Enter endpoint username:"
read username

sudo useradd -m -s $(which bash) $username

echo "Setup password for $username:"
sudo passwd $username

echo "Enter privileged username for registration:"
read priv_username

echo "Setup SSHD for ${username}'s password login: [y/N]"

read setup_sshd

case $setup_sshd in
    [Yy]*) setup_sshd="Y" ;;
    *) setup_sshd="N" ;;
esac

if [ $setup_sshd == "Y" ]; then
    echo "Enter sshd config path: (/etc/ssh/sshd_config)"
    read sshd_path

    if [ -z $sshd_path ]; then
        sshd_path="/etc/ssh/sshd_config"
    fi

    cat <<EOF | sudo tee -a $sshd_path
Match User $username
PasswordAuthentication yes
EOF

    sudo systemctl restart sshd
fi

cat <<EOF | sudo tee /home/$username/.bashrc
trap "" SIGINT

read -s passwd
read -s pubkey
pubkey=(\$pubkey)
pubkey=\${pubkey[0]}

{ echo \$passwd; echo \$pubkey; } | socat UNIX-CONNECT:/tmp/wgreg -

exit
EOF

sudo touch /home/$username/.hushlogin

echo "Setup server system-wide: [Y/n]"

read setup_systemd

case $setup_systemd in
    [Nn]*) setup_systemd="N" ;;
    *) setup_systemd="Y" ;;
esac

if [ $setup_systemd == "Y" ]; then
    ./install_server.sh $priv_username
fi
