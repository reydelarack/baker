#!/bin/bash

# AccountID is required and should match a supernova environment

[[ $# -lt 1 ]] && echo "Usage: $(basename $0) <AccountID> <ImageID> <FlavorID> <Script> <Bypass>" && exit 1

SSHARGS='-q -oConnectTimeout=30 -oCheckHostIP=no -oStrictHostKeyChecking=no -oIdentitiesOnly=yes -oUserKnownHostsFile=/dev/null -oBatchMode=yes'
NAME="baker-`date +%s`"

ACCOUNT=$1
IMAGE=$2
FLAVOR=$3
SCRIPT=$4
BYPASS=$5

BAKERDIR="bash `dirname $(readlink -f $0)`"

UUID=`$BAKERDIR/bootng.sh "$ACCOUNT" "$IMAGE" "$FLAVOR" "$NAME" "$BYPASS"`

IP=`$BAKERDIR/ipng.sh $ACCOUNT $UUID "$BYPASS"`

$BAKERDIR/alive.sh $IP

if [ -n "$SCRIPT" ]; then
	scp $SSHARGS $SCRIPT "root@$IP":/root/.baker-kick.sh &> /dev/null
	ssh $SSHARGS "root@$IP" 'chmod 755 /root/.baker-kick.sh; /root/.baker-kick.sh'
else
	ssh $SSHARGS "root@$IP"
fi

$BAKERDIR/alive.sh $IP

# Nuke unless /root/.baker_preserve exists.
ssh $SSHARGS "root@$IP" stat /root/.baker_preserve &> /dev/null || $BAKERDIR/deleteng.sh $ACCOUNT $UUID "$BYPASS"
