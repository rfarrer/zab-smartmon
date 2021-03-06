#!/bin/bash
version=0.16

while getopts ":Ddf:h:i:p:u:" optname
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
	"p")
	# Get how much of the given pool is used
	# For UserParameter=zfs.zpool.perused[*]
	/sbin/zpool list -H -o capacity $2
	exit 0
	;;
	"u")
	# Get how much of the given pool is used
	# For UserParameter=zfs.zpool.pused[*]
	/sbin/zpool list -H -o capacity $2 | /bin/sed 's/%$//'
	exit 0
	;;
	*)
            # This should not occur!
	    echo "ERROR on `hostname` in $0"
	    exit 1
	;;
	esac
done

