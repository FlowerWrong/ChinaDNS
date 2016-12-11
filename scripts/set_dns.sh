#!/bin/bash

services=$(networksetup -listnetworkserviceorder | grep 'Hardware Port')

while read line; do
    sname=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $2}')
    sdev=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $4}')
    #echo "Current service: $sname, $sdev, $currentservice"
    if [ -n "$sdev" ]; then
        ifconfig $sdev 2>/dev/null | grep 'status: active' > /dev/null 2>&1
        rc="$?"
        if [ "$rc" -eq 0 ]; then
            currentservice="$sname"
        fi
    fi
done <<< "$(echo "$services")"

if [ -n $currentservice ]; then
    echo "current service is $currentservice"
    networksetup -getdnsservers $currentservice
    networksetup -setdnsservers $currentservice 127.0.0.1
    echo "DNS has been seted to 127.0.0.1"
else
    >&2 echo "Could not find current service"
    exit 1
fi
