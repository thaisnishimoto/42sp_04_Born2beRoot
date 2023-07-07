#!/bin/bash

##VARIABLES
ARCH=$(uname -a)
CPU=$(grep "physical id" /proc/cpuinfo | sort --unique | wc -l)
VCPU=$(nproc)
TOTAL_RAM=$(free -m | grep "Mem:" | awk '{print $2}')
USED_RAM=$(free -m | grep "Mem:" | awk '{print $3}')
PCT_RAM=$(free -m | grep "Mem:" | awk '{printf ("%.2f"), ($3 / $2) * 100}')

#The architecture of your operating system and its kernel version.
echo "#Architecture:" $ARCH

#The number of physical processors.
echo "#CPU physical:" $CPU

#The number of virtual processors.
echo "#vCPU:" $VCPU

#The current available RAM on your server and its utilization rate as a percentage.
echo "#Memory Usage: ${USED_RAM}/${TOTAL_RAM}MB (${PCT_RAM}%)"

#The current available memory on your server and its utilization rate as a percentage.
echo "#Disk Usage:"

#The current utilization rate of your processors as a percentage.
echo "#CPU load:"

#The date and time of the last reboot.
echo "#Last boot:"

#Whether LVM is active or not.
echo "#LVM use:"

#The number of active connections.
echo "#Connections TCP:"

#The number of users using the server.
echo "#User log:"

#The IPv4 address of your server and its MAC (Media Access Control) address.
echo "#Network:"

#The number of commands executed with the sudo program.
echo "#Sudo:"
