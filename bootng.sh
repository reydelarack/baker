#!/usr/bin/env bash

ACCOUNT=$1
IMAGE=$2
FLAVOR=$3
NAME=$4
BYPASS=$5

SSHKEY=~/.ssh/id_rsa.pub

function fail() {
	echo $* >&2
	exit 1
}

[ -f "$SSHKEY" ] || fail "$SSHKEY does not exist."

# keypair-add is picky:
SSHUSER="`ssh-keygen -lf $SSHKEY | awk '{print $3}' | tr -d .`"
SSHKEYID="`ssh-keygen -lf $SSHKEY | awk '{print $2}'`"

HASKEY=`supernova $ACCOUNT $BYPASS keypair-list 2> /dev/null | grep $SSHKEYID`
echo $HASKEY | grep -qF "$SSHKEYID" || supernova $ACCOUNT $BYPASS keypair-add \
--pub-key $SSHKEY "$SSHUSER" &> /dev/null

supernova $ACCOUNT $BYPASS boot --disk-config MANUAL --image $IMAGE --flavor $FLAVOR \
--key-name "$SSHUSER" $NAME | grep id | head -n 1 | awk '{print $4}'
