#!/bin/bash

version=0.13

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
		#echo "    {\"{#LINUXDEV}\":\"/dev/sdb\",\"{#VENDOR}\":\"hpt\",\"{#CONTROLLER}\":\"1\",\"{#ARRAY}\":\"1\"}"
		# Below is an example of software RAID
		#echo "    {\"{#LINUXDEV}\":\"/dev/md0\",\"{#VENDOR}\":\"linux\",\"{#CONTROLLER}\":\"NONE\",\"{#ARRAY}\":\"NONE\"}"
		# Below is an example of an LSI based RAID controller
		echo "    {\"{#LINUXDEV}\":\"/dev/sda\",\"{#VENDOR}\":\"lsi\",\"{#CONTROLLER}\":\"0\",\"{#ARRAY}\":\"0\"}"
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
		# Get array overall status
		if [[ $VENDOR == linux ]];
		then
			# Software RAID we get which /dev/mdX device from LINUXDEV
			# XXX: FOR TESTING: 
			###RAIDcmd="../tools/fakeraid.sh 6"
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
			# XXX: FOR TESTING:
			###RAIDcmd="../tools/fakeraid.sh 11"
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

		elif [[ $VENDOR == lsi ]];
		then
			# LSI chipset RAID with MegaCLI tool
			# XXX: FOR TESTING:
			#RAIDcmd="../tools/fakeraid.sh 12" 
			# TODO: this might not work if there are multiple controllers or possibly even multiple arrays as we are getting "all"
			RAIDcmd="/usr/local/sbin/megacli64 -LDInfo -Lall -Aall" 
			RAIDstat=$(exec $RAIDcmd | grep State | sed 's/.*: //')
			if [[ $RAIDstat == Optimal ]];
			then
				ArrayStatus=ONLINE.NORMAL
			elif [[ $RAIDstat == Degraded || $RAIDstat == "Partially Degraded" ]];
			then
				ArrayStatus=ONLINE.DEGRADED
			else
				ArrayStatus=OFFLINE
			fi

		elif [[ $VENDOR == zfs ]];
		then
			# ZFS raidz
			# XXX: FOR TESTING:
			#RAIDcmd="../tools/fakeraid.sh 17" 
			# TODO: FIXME
			RAIDcmd="zpool status" # FIXME 
			RAIDstat=$(exec $RAIDcmd | grep State | sed 's/.*: //') # FIXME
			if [[ $RAIDstat == Optimal ]]; # FIXME
			then
				ArrayStatus=ONLINE.NORMAL
			elif [[ $RAIDstat == Degraded || $RAIDstat == "Partially Degraded" ]]; #FIXME
			then
				ArrayStatus=ONLINE.DEGRADED
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
