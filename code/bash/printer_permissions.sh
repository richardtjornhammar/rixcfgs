#!/bin/bash
if [ "$1" != "" ]; then
    name=$1
else
    name="C460"
fi
#echo $name
variable=$(lsusb | grep $name | awk '{print $2,$4}' | sed 's/:\+$//' | awk  '{print "chmod 0666 /dev/bus/usb/" $1 "/" $2 }')
#echo $variable
sudo $variable

