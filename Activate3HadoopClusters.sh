#!/bin/bash

#========================= (Zookeeper、Broker1、Broker2的IP位置) =========================#
ipmaster=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" master`  # 172.20.0.2
ipslaver1=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver1` # 172.20.0.3
ipslaver2=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver2` # 172.20.0.4



docker exec -i master /bin/bash << ONION
#========================= (關閉各節點的防火牆設定)
# 「ssh -o StrictHostKeyChecking=no $ipslaver1」即可以略過yes方能執行自動化腳本(下兩句等價於本句)
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
service ssh restart

#========================= (定義各機台叢集名稱)
echo "$ipmaster master" >> /etc/hosts
echo "$ipslaver1 slaver1" >> /etc/hosts
echo "$ipslaver2 slaver2" >> /etc/hosts
echo master > /etc/hostname

#========================= (zookeeper啟動時(zkServer.sh(hadoop的start-all.sh會自動啟動zkServer.sh))所讀取節點IP的位置設定)
echo "server.1=master:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.2=slaver1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.3=slaver2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg

#========================= (給zookeeper所管理的叢集之每一機台給定id編號方能使zookeeper管理)
echo 1 > /opt/zookeeper/myid

#========================= (hadoop在master啟動時(start-all.sh)所讀取的變數設定來知道各節點(叢集)的名稱)
echo -e "master\nslaver1\nslaver2" > /opt/hadoop-2.7.3/etc/hadoop/slaves

source /etc/profile

ONION


docker exec -i slaver1 /bin/bash << ONION
#========================= (關閉各節點的防火牆設定)
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
service ssh restart

#========================= (定義各機台叢集名稱)
echo "$ipmaster master" >> /etc/hosts
echo "$ipslaver1 slaver1" >> /etc/hosts
echo "$ipslaver2 slaver2" >> /etc/hosts
echo slaver1 > /etc/hostname

#========================= (zookeeper啟動時(zkServer.sh(hadoop的start-all.sh會自動啟動zkServer.sh))所讀取節點IP的位置設定)
echo "server.1=master:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.2=slaver1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.3=slaver2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg

#========================= (給zookeeper所管理的叢集之每一機台給定id編號方能使zookeeper管理)
echo 2 > /opt/zookeeper/myid

source /etc/profile

ONION


docker exec -i slaver2 /bin/bash << ONION
#========================= (關閉各節點的防火牆設定)
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
service ssh restart

#========================= (定義各機台叢集名稱)
echo "$ipmaster master" >> /etc/hosts
echo "$ipslaver1 slaver1" >> /etc/hosts
echo "$ipslaver2 slaver2" >> /etc/hosts
echo slaver2 > /etc/hostname

#========================= (zookeeper啟動時(zkServer.sh(hadoop的start-all.sh會自動啟動zkServer.sh))所讀取節點IP的位置設定)
echo "server.1=master:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.2=slaver1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.3=slaver2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg

#========================= (給zookeeper所管理的叢集之每一機台給定id編號方能使zookeeper管理)
echo 3 > /opt/zookeeper/myid

source /etc/profile

ONION


#========================= (啟動各節點的zookeeper)
sleep 3; docker exec -i master /bin/bash -c '/opt/zookeeper/bin/zkServer.sh start'
sleep 3; docker exec -i slaver1 /bin/bash -c '/opt/zookeeper/bin/zkServer.sh start'
sleep 3; docker exec -i slaver2 /bin/bash -c '/opt/zookeeper/bin/zkServer.sh start'


#========================= (啟動各節點的journalnode)
sleep 3; docker exec -i master /bin/bash -c 'hadoop-daemon.sh start journalnode'
sleep 3; docker exec -i slaver1 /bin/bash -c 'hadoop-daemon.sh start journalnode'
sleep 3; docker exec -i slaver2 /bin/bash -c 'hadoop-daemon.sh start journalnode'


docker exec -i master /bin/bash << ONION
#建立hdfs namenode:
#========================= (格式化所新增hdfs所需使用的目錄之其檔案系統與zookeeper舊有設定)
source /etc/profile
sleep 3; hdfs namenode -format
sleep 3; hdfs zkfc -formatZK

#========================= (啟動hadoop所需使用的所有服務精靈(start-all.sh))
source /etc/profile
source /etc/profile
sleep 5; start-all.sh

ONION


#========================= (建立HA(即slaver1也有namenode)(HDFS NameNode的高可用(High Availability，HA)方案))
docker exec -i slaver1 /bin/bash << ONION
#hdfs namenode -bootstrapStandby
sleep 3; /opt/hadoop/bin/hdfs namenode -bootstrapStandby

#hadoop-daemon.sh start namenode
sleep 3; /opt/hadoop/sbin/hadoop-daemon.sh start namenode

ONION


