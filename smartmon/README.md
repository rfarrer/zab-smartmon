Zabbix S.M.A.R.T. Monitor

Description:
A hard drive S.M.A.R.T. data monitor for Zabbix.

Features:
Auto discovery of /dev/sdX drives
Will trigger an alert on monitored disk SMART attributes
Drives are probed every 10800 seconds (3 hours)

Install:
1. Make sure smartctl (smartmontools) is installed
2. Add these three lines to zabbix agent config 
	UserParameter=smartmon.discovery,sudo /usr/local/bin/smartmon.sh -D
	UserParameter=smartmon.value[*],sudo /usr/local/bin/smartmon.sh -d $1.$2 -v $3
	UserParameter=smartmon.health[*],sudo /usr/local/bin/smartmon.sh -d $1.$2 -t
3. Import smart_monitor.xml on Zabbix Monitoring Server
4. Manually add any RAID devices to smartmon.sh (see example within)
5. Make sure zabbix can sudo (to run smartctl)

Common Problems:
If you get an error similar to "not a valid JSON query" under discovery, you
probably have an extra comma in your list line of disk discovery in
smartmon.sh. The last line cannot have a comma.

If all of the SMART values show as "not supported" you most likely need to
install smartctl on the monitored machine.

If you get alerts that zabbix cannot sudo, you need to give zabbix the ability
to sudo on the monitored machine and without a password. For example add "zabbix 
ALL=(ALL) NOPASSWD:ALL" to your sudoers configuration.

If a drive is missing from the listing, make sure it is not being removed by
grep in the discovery section of smartmon.sh or if it is RAID make sure it is
manually listed in same file.

Some drives only give Temperature_Celsius, some only give
Airflow_Temperature_Cel, and some give both. So in smartmon.xml we look for
Temperature_Cel (which will catch both) and in smartmon.sh we only take the
first output. On drives that provide both temperatures there is no guarantee
which one will show up first. This should only be a minor problem and is the
result of S.M.A.R.T not being an official set of standards.

Special Thanks:
Based on works by Kevin Druelle (kdruelle on github)

