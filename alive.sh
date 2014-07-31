#!/bin/bash

IP=$1
SSHARGS=$2
USER=$3

[ -z "$IP" ] && exit 1
[ -z "$SSHARGS" ] && exit 1
[ -z "$USER" ] && exit 1

(while ! ssh $SSHARGS "$USER@$IP" true; do
	sleep 1
	continue
done) &> /dev/null
