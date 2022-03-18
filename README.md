# git-server-init

Automation for setting up a simple git server. 
No WebUIs, no HTTPs urls. 

Just SSH pushing/pulling, and a simple CLI when you login interactively.


# usage

Run the `init.sh` script. It takes two arguments.

The first is the IP of the server. You should be able to login as root with a password.

The second is the path on the server where you would like to store git data.

## EX
```
./init.sh 192.0.0.1 /home/git
```
