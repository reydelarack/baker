#!/bin/bash

# AccountID is required and should match a supernova environment
# <Scripts> can be a space separated list of filenames to uploaded. First one
# in list will be ran after all others have been uploaded. They will be uploaded
# to /root/.baker/.

[[ $# -lt 1 ]] && echo "Usage: $(basename $0) <AccountID> <ImageID> <FlavorID> <Script> <Bypass>" && exit 1

# -l $USER doesn't work with scp.
SSHARGS="-q -oConnectTimeout=30 -oCheckHostIP=no -oStrictHostKeyChecking=no -oIdentitiesOnly=yes -oUserKnownHostsFile=/dev/null -oBatchMode=yes -oVerifyHostKeyDNS=no"

ACCOUNT=${1:-default}
IMAGE=${2:-f0b8595d-128e-4514-a5cc-847429dcfa6b}
FLAVOR=${3:-performance1-1}
SCRIPT=$4
BYPASS=$5
NAME=${6:-"baker-`date +%s`"}

# This bit is an ugly hack.
BAKERDIR="bash `dirname $(readlink -f $0)`"

USER=root
OTHERUSER=`supernova $ACCOUNT $BYPASS image-show $IMAGE | grep com.rackspace__1__ssh_user | awk '{print $5}'`
[ -n "$OTHERUSER" ] && USER=$OTHERUSER


UUID=`$BAKERDIR/bootng.sh "$ACCOUNT" "$IMAGE" "$FLAVOR" "$NAME" "$BYPASS"` || exit 1

IP=`$BAKERDIR/ipng.sh $ACCOUNT $UUID "$BYPASS"`

$BAKERDIR/alive.sh $IP "$SSHARGS" $USER

if [ -n "$SCRIPT" ]; then
	export first second
	for include in $SCRIPT; do # Cannot have spaces in filenames.
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
# 's so that ~ is not turned to local $HOME.
ssh $SSHARGS "$USER@$IP" stat '~/.baker_preserve' &> /dev/null || $BAKERDIR/deleteng.sh $ACCOUNT $UUID "$BYPASS"
