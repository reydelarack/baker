#!/bin/bash

IP=$1
SSHARGS='-q -oConnectTimeout=10 -oCheckHostIP=no -oStrictHostKeyChecking=no -oIdentitiesOnly=yes -oUserKnownHostsFile=/dev/null -oBatchMode=yes -o VerifyHostKeyDNS=no'

[ -z "$IP" ] && exit 1

(while ! ssh $SSHARGS "root@$IP" true; do
	sleep 1
	continue
done) &> /dev/null
