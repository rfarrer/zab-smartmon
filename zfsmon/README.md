Zabbix ZFS Monitor

Description:
A ZFS monitor for Zabbix.

Features:
Will trigger an alert on monitored ZFS status

Install:
1. Add the lines from zfsmon.conf to zabbix agent config
2. Import zfsmon.xml on Zabbix Monitoring Server

Common Problems:
If you get alerts that zabbix cannot sudo, you need to give zabbix the ability
to sudo on the monitored machine and without a password. For example add "zabbix 
ALL=(ALL) NOPASSWD:ALL" to your sudoers configuration.

