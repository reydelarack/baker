#!/bin/bash

IP=$1
SSHARGS='-q -oConnectTimeout=30 -oCheckHostIP=no -oStrictHostKeyChecking=no -oIdentitiesOnly=yes -oUserKnownHostsFile=/dev/null -oBatchMode=yes -o VerifyHostKeyDNS=no'

[ -z "$IP" ] && exit 1

(while ! ping -t 1 -n -c 1 "$IP"; do
        continue
done

while ! ssh $SSHARGS "root@$IP" true; do
	sleep 1
	continue
done) &> /dev/null
