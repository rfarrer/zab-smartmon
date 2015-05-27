#!/bin/bash

version=0.12

while getopts ":Dd:s" optname
do
    case "$optname" in
    "D")
        # Disk Discovery 
		echo "{"
        echo "\"data\":["
		# RAID devices
		# # TODO: Manually add hardware RAID or other devices here. Make sure the last entry does not end with a comma
		# The LINUXDEV is the name/location that the arrays shows up as in Linux
		# Below is an example of a HighPoint RAID array that is accessible via /dev/sdb
		echo "    {\"{#LINUXDEV}\":\"/dev/sdb\",\"{#VENDOR}\":\"hpt\",\"{#CONTROLLER}\":\"1\",\"{#ARRAY}\":\"1\"}"
		# Below is an example of software RAID
		#echo "    {\"{#LINUXDEV}\":\"/dev/md0\",\"{#VENDOR}\":\"linux\",\"{#CONTROLLER}\":\"NONE\",\"{#ARRAY}\":\"NONE\"}"
        echo "]"
        echo "}"
        exit 0
    ;;
    "d")
        # Which device and type are we working with when called
		LINUXDEV=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $1;}')
		VENDOR=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $2;}')
		CONTROLLER=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $3;}')
		ARRAY=$(/bin/echo $OPTARG | /usr/bin/awk -F "." '{print $4;}')
    ;;
    "s")
    	# Get array overall status
		# FIXME
		# Get array overall status
		if [[ $VENDOR == linux ]];
		then
			# Software RAID we get which /dev/mdX device from LINUXDEV
			# FIXME: FOR TESTING: 
			###RAIDcmd="../fakeraid.sh 6"
			RAIDcmd="cat /proc/mdstat"
			RAIDstat=$(exec $RAIDcmd | grep "$(echo $LINUXDEV | sed 's/\/dev\///') :" | awk '{print $3;}')
			RAIDrec=$(exec $RAIDcmd | grep -A2 "$(echo $LINUXDEV | sed 's/\/dev\///') :" | grep -q recovery ; echo $?)
			RAIDdisk=$(exec $RAIDcmd | grep -A1 "$(echo $LINUXDEV | sed 's/\/dev\///') :" | grep -q _ ; echo $?)

			if [[ $RAIDstat == active && $RAIDrec == 1 && $RAIDdisk == 1 ]];
			then
				ArrayStatus=ONLINE.NORMAL
			elif [[ $RAIDstat == active && $RAIDrec == 0 || $RAIDdisk == 0 ]];
			then
				ArrayStatus=ONLINE.DEGRADED
			else
				ArrayStatus=OFFLINE
			fi

		elif [[ $VENDOR == hpt ]];
		then
			# HighPoint RocketRAID
			# FIXME: FOR TESTING:
			###RAIDcmd="../fakeraid.sh 11"
			RAIDcmd="hptraidconf query arrays $ARRAY -u RAID -p hpt"
			RAIDstat=$(exec $RAIDcmd | grep "Status:" | awk '{print $4;}')
			RAIDrec=$(exec $RAIDcmd | grep "Progress" | grep -q "\--" ; echo $?)
			RAIDdisk=$(exec $RAIDcmd | grep -q "NORMAL" ; echo $?)

			if [[ $RAIDstat == NORMAL && $RAIDrec == 0 && $RAIDdisk == 0 ]];
			then
				ArrayStatus=ONLINE.NORMAL
			elif [[ $RAIDstat != NORMAL && $RAIDstat == CRITICAL || $RAIDrec == 1 || $RAIDdisk == 1 ]];
			then
				ArrayStatus=ONLINE.DEGRADED
			else
				ArrayStatus=OFFLINE
			fi

		elif [[ $VENDOR == 3ware ]];
		then
			# 3ware RAID
			RAIDCMD=FIXME
			RAIDstat=""
			RAIDrec=""
			RAIDdisk=""
			if [[ $RAIDstat == FIXME ]];
			then
				ArrayStatus=ONLINE
			else
				ArrayStatus=OFFLINE
			fi
		else
			echo "unknown RAID device. Please add it to `hostname` $0"
		fi
		# Report what we discovered about the array
		echo $ArrayStatus
		exit 0
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
