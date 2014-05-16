#!/bin/bash

ACCOUNT=$1
UUID=$2
BYPASS=$3

while [ -z "$IP" ]; do
	sleep 1
        IP="`supernova $ACCOUNT $BYPASS show --minimal $UUID | grep accessIPv4 | head -n 1 | awk '{print $4}' | tr -d '|'`"
done

echo $IP
