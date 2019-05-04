#!/bin/bash
 [ `docker images | grep 'oniontraveler/hadoop_container' | cut -d ' ' -f 1,4 --output-delimiter=':'` ] && echo "The image 「oniontraveler/hadoop_container:19.5.4」 has existed！" || docker build -f ./myDockerfiles/onionfile -t oniontraveler/hadoop_container:19.5.4 .

docker run -itd --name master --hostname master -p 50070:50070 -p 8088:8088 -p 8080:8080 oniontraveler/hadoop_container:19.5.4
docker run -id --name slaver1 --hostname slaver1 oniontraveler/hadoop_container:19.5.4
docker run -td --name slaver2 --hostname slaver2 oniontraveler/hadoop_container:19.5.4


#========================= (port explanation)
# -p 50070:50070  -> HDFS
# -p 8088:8088    -> YARN
# -p 8080:8080    -> Spark


#========================= (docker commands for entering into the container(master or slaver1))
# docker exec -it master /bin/bash
# docker exec -it slaver1 /bin/bash
