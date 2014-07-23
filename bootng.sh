#!/bin/bash

ACCOUNT=${1:-default}
IMAGE=${2:-f0b8595d-128e-4514-a5cc-847429dcfa6b}
FLAVOR=${3:-performance1-1}
NAME=${4:-"baker-`date +%s`"}
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
