#!/bin/bash

#help function
function usage(){
	printf "\nUsage: $0 [ IP of server ] [ Directory for git storage ]\n
	Options:
		[ IP of server ] - self explanatory.
		[ Directory for git storage ] - home directory for 'git' user. Stores all repositories, authorized ssh keys, and additional git-shell commands.\n\n"
	exit 1
}

# if no args
if [ $# -eq 0 ]; then
	usage
	exit 1
fi

# copy ssh key
ssh-copy-id root@$1

# copy over server script
scp ./server-init.sh root@$1:~/ >/dev/null 2>&1

# generate initial ssh key for `git` user
ssh-keygen -f $(pwd)/id_rsa

# run configuration script on server
ssh root@$1 bash /root/server-init.sh $2

# remove configuration script from server
ssh root@$1 rm /root/server-init.sh

# scp over key
scp ./id_rsa.pub root@$1:$2/.ssh/authorized_keys >/dev/null 2>&1

# verify key permissions
ssh root@$1 chmod 600 $2/.ssh/authorized_keys

# scp over git-shell-commands
scp -r $(pwd)/git-shell-commands root@$1:$2/ >/dev/null 2>&1

# add execute perms to scripts
ssh root@$1 chmod u+x $2/git-shell-commands/*

# verify ownership
ssh root@$1 chown -R git $2
