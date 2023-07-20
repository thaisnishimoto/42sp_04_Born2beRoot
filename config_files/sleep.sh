#!/bin/bash

BOOT_MIN=$(uptime -s | awk -F ':' '{print $2}')

DELAY_TIME=$((${BOOT_MIN}%10*60))

sleep ${DELAY_TIME}
