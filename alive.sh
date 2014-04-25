#!/bin/bash

IP=$1

[ -z "$IP" ] && exit 1

(while ! ping -t 1 -n -c 1 "$IP"; do
        continue
done

while ! nc -z "$IP" 22; do
        continue
done) &> /dev/null
