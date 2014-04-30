#!/bin/bash

ACCOUNT=$1
IMAGE=${2:-e5d7ca78-a487-4d7e-9dd1-73165df3f9fd}
FLAVOR=${3:-performance1-1}
NAME=${4:-"baker-`date +%s`"}
BYPASS=$5

SSHKEY=~/.ssh/id_rsa.pub

supernova $ACCOUNT $BYPASS boot --disk-config MANUAL --image $IMAGE --flavor $FLAVOR \
--file /root/.ssh/authorized_keys=$SSHKEY $NAME  | grep id | head -n 1 | awk '{print $4}'
