Zabbix RAID Monitor

Description:
A RAID monitor for Zabbix.

Features:
Will trigger an alert on monitored RAID status
Arrays are probed every 10800 seconds (3 hours)

Install:
1. Make sure whatever appropriate RAID utility for your controller is installed (software RAID excluded)
2. Add these lines to zabbix agent config:
	UserParameter=raidmon.discovery,sudo /usr/local/bin/raidmon.sh -D
	UserParameter=raidmon.status[*],sudo /usr/local/bin/raidmon.sh -d $1.$2.$3.$4 -s
3. Import raid_monitor.xml on Zabbix Monitoring Server
4. Manually add any RAID devices to raidmon.sh (see example within)
5. Make sure zabbix can sudo (to run the needed RAID controller utility)

Common Problems:
If you get an error similar to "not a valid JSON query" under discovery, you
probably have an extra comma in your list line of disk discovery in
raidmon.sh. The last line cannot have a comma.

If you get alerts that zabbix cannot sudo, you need to give zabbix the ability
to sudo on the monitored machine and without a password. For example add "zabbix 
ALL=(ALL) NOPASSWD:ALL" to your sudoers configuration.

