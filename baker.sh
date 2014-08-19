#!/usr/bin/env bash

# AccountID is required and should match a supernova environment
# <Scripts> can be a space separated list of filenames to uploaded. First one
# in list will be ran after all others have been uploaded. They will be uploaded
# to /root/.baker/.

[[ $# -lt 1 ]] && echo "Usage: $(basename $0) <AccountID> <ImageID> <FlavorID> <Script> <Bypass>" && exit 1

# -l $USER doesn't work with scp, so not using that here.
SSHARGS="-q -oConnectTimeout=30 -oCheckHostIP=no -oStrictHostKeyChecking=no -oIdentitiesOnly=yes -oUserKnownHostsFile=/dev/null -oBatchMode=yes -oVerifyHostKeyDNS=no"

ACCOUNT=${1:-default}
IMAGE=${2:-f0b8595d-128e-4514-a5cc-847429dcfa6b}
FLAVOR=${3:-performance1-1}
SCRIPT=$4
BYPASS=$5
NAME=${6:-"baker-`date +%s`"}

USER=root
OTHERUSER=`supernova $ACCOUNT $BYPASS image-show $IMAGE | grep com.rackspace__1__ssh_user | awk '{print $5}'`
[ -n "$OTHERUSER" ] && USER=$OTHERUSER

SSHKEY=~/.ssh/id_rsa.pub

##### Boot the server
[ -f "$SSHKEY" ] || fail "$SSHKEY does not exist."
# keypair-add is picky:
SSHKEYID="`ssh-keygen -lf $SSHKEY | awk '{print $2}'`"
SSHUSER="`echo $SSHKEYID | tr -d ':'`"

HASKEY="`supernova $ACCOUNT $BYPASS keypair-list 2> /dev/null | grep -F $SSHKEYID`"
[ -n "$HASKEY" ] && SSHUSER="`echo $HASKEY | awk '{print $2}'`"

# If there's no key on the region/account, push it so we can use it.
echo $HASKEY | grep -qF "$SSHKEYID" || supernova $ACCOUNT $BYPASS keypair-add --pub-key $SSHKEY "$SSHUSER" &> /dev/null

UUID=$(supernova $ACCOUNT $BYPASS boot --image $IMAGE --flavor $FLAVOR --key-name "$SSHUSER" $NAME 2> /dev/null | grep id | head -n 1 | awk '{print $4}')
#####

#### Wait for IP
while [ -z "$IP" ]; do
        sleep 1
        IP="`supernova $ACCOUNT $BYPASS show --minimal $UUID 2> /dev/null | grep accessIPv4 | head -n 1 | awk '{print $4}' | tr -d '|'`"
done
####

#### Wait till it's booted.
(while ! ssh $SSHARGS "$USER@$IP" true; do
        sleep 1
        continue
done) &> /dev/null
####

#### Script it or SSH to it?
if [ -n "$SCRIPT" ]; then
	export first second
	for include in $SCRIPT; do # Cannot have spaces, tabs, or newlines in filenames.
		if [ -z "$first" ]; then
			scp $SSHARGS "$include" "$USER@$IP":/root/.baker-kick &> /dev/null
			first=1
		else
			if [ -z "$second" ]; then
				ssh $SSHARGS "$USER@$IP" 'mkdir /root/.baker/'
				second=1
			fi
			scp $SSHARGS "$include" "$USER@$IP":/root/.baker/ &> /dev/null
		fi
	done
	ssh $SSHARGS "$USER@$IP" 'chmod 755 /root/.baker-kick; /root/.baker-kick'
	unset first second
else
	ssh $SSHARGS "$USER@$IP"
fi

# Nuke unless ~/.baker_preserve exists.
# The single quotes are so that ~ is not turned to local $HOME.
ssh $SSHARGS "$USER@$IP" stat '~/.baker_preserve' &> /dev/null || supernova $ACCOUNT $BYPASS delete $UUID &> /dev/null
