#!/bin/bash

RT=$1


if [ $RT -eq 0 ];
then
echo "Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6]
md0 : active raid6 sdf1[0] sde1[1] sdd1[2] sdc1[3] sdb1[4] sda1[5] hdb1[6]
      1225557760 blocks level 6, 256k chunk, algorithm 2 [7/7] [UUUUUUU]
      bitmap: 0/234 pages [0KB], 512KB chunk

unused devices: <none>"

elif [ $RT -eq 1 ];
then
echo "Personalities : [raid1] [raid6] [raid5] [raid4]
md_d0 : active raid5 sde1[0] sdf1[4] sdb1[5] sdd1[2] sdc1[1]
      1250241792 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 0/10 pages [0KB], 16384KB chunk

unused devices: <none>"

elif [ $RT -eq 2 ];
then
echo "Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdd1[2] sdb1[1]
     1465151808 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
    unused devices: <none>"

elif [ $RT -eq 3 ];
then
echo "Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
      136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
      129596288 blocks [2/2] [UU]

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
      1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

md0 : active raid1 sdb1[1] sda1[0]
      16787776 blocks [2/2] [UU]

unused devices: <none>"

elif [ $RT -eq 4 ];
then
echo "Personalities : [raid1] [raid6] [raid5] [raid4]
md127 : active raid5 sdh1[6] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
      1464725760 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
      [==>..................]  recovery = 12.6% (37043392/292945152) finish=127.5min speed=33440K/sec

unused devices: <none>"

elif [ $RT -eq 5 ];
then
echo "Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6]
md0 : active raid6 sdf1[0] sde1[1] sdd1[2] sdc1[3] sdb1[4] sda1[5] hdb1[6]
      1225557760 blocks level 6, 256k chunk, algorithm 2 [7/7] [UU_UUUU]
      bitmap: 0/234 pages [0KB], 512KB chunk

unused devices: <none>"

elif [ $RT -eq 6 ];
then
echo "Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 sdh1[6] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
      1464725760 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUUU]
      [==>..................]  recovery = 12.6% (37043392/292945152) finish=127.5min speed=33440K/sec

unused devices: <none>"

elif [ $RT -eq 7 ];
then
echo "ID:             1                   Name:           RAID_5_0
Type:           RAID5               Status:         NORMAL
Capacity(GB):   1500.08             BlockSize:      64k
SectorSize:     512B                CachePolicy:    WB
Progress:       --
ID      Capacity    MaxFree     Flag    Statue    ModelNumber
-------------------------------------------------------------------------------
1/1     500.03      0           NORMAL  RAID      TOSHIBA DT01ACA050
1/2     500.03      0           NORMAL  RAID      Hitachi HDS721050CLA362
1/3     500.03      0           NORMAL  RAID      ST500LM012 HN-M500MBB
1/4     750.08      250.05      NORMAL  RAID      Hitachi HTS547575A9E384
-------------------------------------------------------------------------------"

elif [ $RT -eq 8 ];
then
echo "ID:             1                   Name:           RAID_5_0
Type:           RAID5               Status:         NORMAL
Capacity(GB):   1500.08             BlockSize:      64k
SectorSize:     512B                CachePolicy:    WB
Progress:       12.5%
ID      Capacity    MaxFree     Flag    Statue    ModelNumber
-------------------------------------------------------------------------------
1/1     500.03      0           NORMAL  RAID      TOSHIBA DT01ACA050
1/2     500.03      0           NORMAL  RAID      Hitachi HDS721050CLA362
1/3     500.03      0           NORMAL  RAID      ST500LM012 HN-M500MBB
1/4     750.08      250.05      NORMAL  RAID      Hitachi HTS547575A9E384
-------------------------------------------------------------------------------"

elif [ $RT -eq 9 ];
then
echo "ID:             1                   Name:           RAID_5_0
Type:           RAID5               Status:         CRITICAL
Capacity(GB):   1500.08             BlockSize:      64k
SectorSize:     512B                CachePolicy:    WB
Progress:       12.5%
ID      Capacity    MaxFree     Flag    Statue    ModelNumber
-------------------------------------------------------------------------------
1/1     500.03      0           NORMAL  RAID      TOSHIBA DT01ACA050
1/2     500.03      0           NORMAL  RAID      Hitachi HDS721050CLA362
1/3     500.03      0           NORMAL  RAID      ST500LM012 HN-M500MBB
1/4     750.08      250.05      NORMAL  RAID      Hitachi HTS547575A9E384
-------------------------------------------------------------------------------"

elif [ $RT -eq 10 ];
then
echo "ID:             1                   Name:           RAID_5_0
Type:           RAID5               Status:         CRITICAL
Capacity(GB):   1500.08             BlockSize:      64k
SectorSize:     512B                CachePolicy:    WB
Progress:       --
ID      Capacity    MaxFree     Flag    Statue    ModelNumber
-------------------------------------------------------------------------------
1/1     500.03      0           NORMAL  RAID      TOSHIBA DT01ACA050
1/2     500.03      0           NORMAL  RAID      Hitachi HDS721050CLA362
1/3     500.03      0           CRITICAL  RAID      ST500LM012 HN-M500MBB
1/4     750.08      250.05      NORMAL  RAID      Hitachi HTS547575A9E384
-------------------------------------------------------------------------------"

elif [ $RT -eq 11 ];
then
echo "ID:             1                   Name:           RAID_5_0
Type:           RAID5               Status:         BUGGERED
Capacity(GB):   1500.08             BlockSize:      64k
SectorSize:     512B                CachePolicy:    WB
Progress:       --
ID      Capacity    MaxFree     Flag    Statue    ModelNumber
-------------------------------------------------------------------------------
1/1     500.03      0           NORMAL  RAID      TOSHIBA DT01ACA050
1/2     500.03      0           NORMAL  RAID      Hitachi HDS721050CLA362
1/3     500.03      0           CRITICAL  RAID      ST500LM012 HN-M500MBB
1/4     750.08      250.05      NORMAL  RAID      Hitachi HTS547575A9E384
-------------------------------------------------------------------------------"



fi

