#!/bin/bash

# set path for git home directory
path=$1

# update system and install git
printf "\n\nUpdating System.\n"
apt-get update >/dev/null 2>&1
apt-get full-upgrade -y >/dev/null 2>&1
apt-get install git -y >/dev/null 2>&1

printf "Adding 'git' user.\n"
# add git-shell as a system shell if not already
if grep -Fxq "git-shell" /etc/shells
then
	echo
else
	echo $(which git-shell) >> /etc/shells
fi

# create git user and directory
mkdir $path
useradd git -d $path

chown -R git $path

chmod 750 $path

# set shell for account to git-shell
chsh git -s $(which git-shell)

printf "Configuring sshd.\n"
# harden and reconfigure sshd
sed -i -e 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

cat >>/etc/ssh/sshd_config <<\EOF
Match user git
	AllowTCPForwarding no
	X11Forwarding no
	AllowAgentForwarding no
	GatewayPorts no
EOF

# restart sshd
systemctl restart sshd

printf "Installing git-shell commands.\n"
# quiet up default ssh entry prints
touch $path/.hushlogin

# create .ssh directory
mkdir $path/.ssh
chmod 700 $path/.ssh

