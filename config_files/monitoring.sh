#!/bin/bash

#VARIABLES
ARCH=$(uname -a)
CPU=$(grep "physical id" /proc/cpuinfo | sort --unique | wc -l)
VCPU=$(nproc)

TOTAL_RAM=$(free -m | grep "Mem:" | awk '{print $2}')
USED_RAM=$(free -m | grep "Mem:" | awk '{print $3}')
PCT_RAM=$(free -m | grep "Mem:" | awk '{printf ("%.2f"), ($3 / $2) * 100}')

TOTAL_STG=$(df -h --total | grep "total" | awk '{print $2}')
USED_STG=$(df -m --total | grep "total" | awk '{print $3}')
PCT_STG=$(df -h --total | grep "total" | awk '{printf $5}')

USED_CPU=$(mpstat | grep all | awk '{printf(100 - $NF)}')

LST_BOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
#LST_BOOT=$(who -b | awk '{print $3 " " $4}')

LVM_USE=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)

TCP_CONN=$(ss -t | grep "established" | wc -l)
#TCP_CONN=$(ss -s | grep "TCP:" | awk '{print $2}')

USR_LOG=$(who | wc -l)

IP=$(hostname -I | awk '{print $1}')
MAC=$(ip link | grep "ether" | awk '{print $2}')
#MAC=$(ip -br link show | grep "ether" | awk '{print $2}')

SUDO=$(cat /var/log/sudo/sudo.log | grep "USER" | wc -l)


#The architecture of your operating system and its kernel version.
echo "#Architecture:" $ARCH

#The number of physical processors.
echo "#CPU physical:" $CPU

#The number of virtual processors.
echo "#vCPU:" $VCPU

#The current available RAM on your server and its utilization rate as a percentage.
echo "#Memory Usage: ${USED_RAM}/${TOTAL_RAM}MB (${PCT_RAM}%)"

#The current available memory on your server and its utilization rate as a percentage.
echo "#Disk Usage: ${USED_STG}/${TOTAL_STG} ${PCT_STG}"

#The current utilization rate of your processors as a percentage.
echo "#CPU Usage: ${USED_CPU}%"

#The date and time of the last reboot.
echo "#Last boot: ${LST_BOOT}"

#Whether LVM is active or not.
echo "#LVM use:" ${LVM_USE}

#The number of active connections.
echo "#TCP Connections: ${TCP_CONN} ESTABLISHED"

#The number of users using the server.
echo "#User log: ${USR_LOG}"

#The IPv4 address of your server and its MAC (Media Access Control) address.
echo "#Network: IP ${IP} (${MAC})"

#The number of commands executed with the sudo program.
echo "#Sudo: ${SUDO} cmd"
