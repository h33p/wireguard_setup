#!/usr/bin/env bash

echo "Enter endpoint username:"
read username

sudo useradd $username

echo "Setup password for $username:"
sudo passwd $username

echo "Enter privileged username for registration:"
read priv_username

echo "Setup SSHD for ${username}'s password login: [y/N]"

read setup_sshd

case $yn in
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
PrintMotd no
PrintLastLog no
EOF

    sudo systemctl restart sshd
fi

default_wgsetup="server_config.sh"

echo "Enter wireguard setup command: ($default_wgsetup)"

read wgsetup

if [[ -z $wgsetup ]]; then
    wgsetup=$default_wgsetup
fi

cat <<EOF | sudo tee /home/$username/.bashrc
read -s passwd
read -s pubkey
pubkey=(\$pubkey)
pubkey=\${pubkey[0]}

{ echo \$passwd; echo \$passwd; } | su -l $priv_username -c "sudo -S $wgsetup peer \$pubkey"

exit
EOF

sudo touch /home/$username/.hushlogin
