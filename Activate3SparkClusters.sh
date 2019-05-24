#!/bin/bash

#========================= (Zookeeper、Broker1、Broker2的IP位置) =========================#
ipmaster=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" master`  # 172.20.0.2
ipslaver1=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver1` # 172.20.0.3
ipslaver2=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver2` # 172.20.0.4



docker exec -i master /bin/bash << ONION
#========================= (spark啟動時(start-all.sh)所讀取節點IP的位置設定) (那空白不能略!!)
cp /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves.template /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves
cat >> /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves << onion

$ipslaver1
$ipslaver2
onion

ONION


docker exec -i slaver1 /bin/bash << ONION
#========================= (spark啟動時(start-all.sh)所讀取節點IP的位置設定) (那空白不能略!!)
cp /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves.template /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves
cat >> /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves << onion

$ipslaver1
$ipslaver2
onion

ONION


docker exec -i slaver2 /bin/bash << ONION
#========================= (spark啟動時(start-all.sh)所讀取節點IP的位置設定) (那空白不能略!!)
cp /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves.template /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves
cat >> /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves << onion

$ipslaver1
$ipslaver2
onion

ONION


#========================= (啟動Spark資源管理器(Spark Standalone))
docker exec -i master /bin/bash -c 'source /opt/spark/sbin/start-all.sh'


