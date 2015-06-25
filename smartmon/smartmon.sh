#!/bin/bash

version=0.39

while getopts ":Dd:v:t" optname
do
    case "$optname" in
    "D")
        # Disk Discovery 
	#
	echo "{"
        echo "\"data\":["
	# RAID devices
	#
	# Manually add hardware RAID or other devices here 
	# The RAIDDEV is a special name (see section "a" below. If the device is part of software RAID put its mdX number as the short name
	# The DISKTYPE portion is what smartctl uses. In the first example it is a highpoint card (hpt), fourth device/disk (1/4) and on the first array
	#Example: echo "    {\"{#RAIDDEV}\":\"3WARE\",\"{#DISKNAME}\":\"/dev/twa0\",\"{#DISKTYPE}\":\"3ware,0\",\"{#SHORTDISKNAME}\":\"twa0\"},"
	# Below is an example of a four disk HighPoint RAID array that is accessible via /dev/sdb
	#echo "    {\"{#DISKNAME}\":\"/dev/sdb\",\"{#DISKTYPE}\":\"hpt,1/1/1\",\"{#SHORTDISKNAME}\":\"sdbone\"},"
	#echo "    {\"{#DISKNAME}\":\"/dev/sdb\",\"{#DISKTYPE}\":\"hpt,1/2/1\",\"{#SHORTDISKNAME}\":\"sdbtwo\"},"
	#echo "    {\"{#DISKNAME}\":\"/dev/sdb\",\"{#DISKTYPE}\":\"hpt,1/3/1\",\"{#SHORTDISKNAME}\":\"sdbthree\"},"
	#echo "    {\"{#DISKNAME}\":\"/dev/sdb\",\"{#DISKTYPE}\":\"hpt,1/4/1\",\"{#SHORTDISKNAME}\":\"sdbfour\"},"
	#
	# TODO: add any drives listed above in this list to keep it from being rediscovered below in the form of: "sda|sdb|sdc"
	#
	IgnoreDisks="sdz"
	#
	# Autodiscovery of standard /dev/sdX drives
	#
        disks=$(ls -l /dev/disk/by-id/ | grep -v part | grep -v total | grep -vE '('$IgnoreDisks')' | grep -vE 'sr[0-9]' | sed 's/.*..\///' | sed 's/^/\/dev\//' | sort | uniq)
        typeset -i nbLines
        typeset -i cntLines=0
        nbLines=$(ls -l /dev/disk/by-id/ | grep -v part | grep -v total | grep -vE '('$IgnoreDisks')' | grep -vE 'sr[0-9]' | sed 's/.*..\///' | sed 's/^/\/dev\//' | sort | uniq | wc -l)
        for disk in $disks
        do
            cntLines=${cntLines}+1
            if [ ${cntLines} -eq ${nbLines} ]; then
                echo "    {\"{#DISKNAME}\":\"$disk\",\"{#DISKTYPE}\":\"sat\",\"{#SHORTDISKNAME}\":\"${disk:5}\"}"
            else
                echo "    {\"{#DISKNAME}\":\"$disk\",\"{#DISKTYPE}\":\"sat\",\"{#SHORTDISKNAME}\":\"${disk:5}\"},"
            fi
        done
        echo "]"
        echo "}"
        exit 0
    ;;
    "d")
        # Which device and type are we working with when called
	DeviceType=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $1;}')
	Device=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $2;}')
    ;;
    "v")
        # Which value to get for the device
        /usr/sbin/smartctl -d $DeviceType -A $Device | grep $OPTARG | head -1 | awk 'NF>1{print $(NF-1), $NF}' | grep -oE '([0-9][0-9])'
        exit 0
    ;;
    "t") 
    	# Get overall SMART health information: usually "PASSED" if all is well
       	health=$(/usr/sbin/smartctl -d $DeviceType -a $Device | grep -i health | awk 'NF>1{print $NF}')
	if [[ $health == "PASSED" || $health == "OK" ]];
	then
		echo 'PASSED'
		exit 0
	else
		echo 'FAILED!'
		exit 2
	fi
    ;;
    "?")
        echo "Unknown option $OPTARG"
        exit 1
    ;;
    ":")
        echo "No argument value for option $OPTARG"
        exit 1
    ;;
    *)
        # This should not occur!
        echo "ERROR on `hostname` in $0"
        exit 1
    ;;
    esac
done
