#!/bin/bash
version=0.15

while getopts ":Ddf:h:i:" optname
do
    case "$optname" in
        "D")
	# Get the list of pools
	# For UserParameter=zfs.pool.discovery
	/sbin/zpool list -H -o name | /usr/bin/gawk 'BEGIN {print "{ \"data\":["} {print((NR==1)?"":",") "{\"{#POOLNAME}\":\""$1"\"}"} END {print "]}"}'
	exit 0
	;;
	"d")
	# Get the list of pool names
	# For UserParameter=zfs.fileset.discovery
	/sbin/zfs list -H -o name | /usr/bin/gawk 'BEGIN {print "{ \"data\":["} {print((NR==1)?"":",") "{\"{#FILESETNAME}\":\""$1"\"}"} END {print "]}"}'
	exit 0
	;;
	"h")
	# Get the health of the given pool
	# For UserParameter=zfs.zpool.health[*]
	/sbin/zpool list -H -o health $2
	exit 0
	;;
	"i")
	# Get the filesystem informaton about the given pool name
	# For UserParameter=zfs.get.fsinfo[*]
	/sbin/zfs get -o value -Hp $3 $2
	exit 0
	;;
	*)
            # This should not occur!
	    echo "ERROR on `hostname` in $0"
	    exit 1
	;;
	esac
done

