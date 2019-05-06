#!/bin/bash
 [ `docker images | grep 'oniontraveler/hadoop_container' | cut -d ' ' -f 1,4 --output-delimiter=':'` ] && echo "The image 「oniontraveler/hadoop_container:19.5.4」 has existed！" || docker build -f ./myDockerfiles/onionfile -t oniontraveler/hadoop_container:19.5.4 .

 [ `docker ps -a | grep 'master' | rev | cut -d ' ' -f 1 | rev` ] && echo "The container 「master 」 has existed" || docker run -itd --name master --hostname master -p 50070:50070 -p 8088:8088 -p 8080:8080 oniontraveler/hadoop_container:19.5.4
 [ `docker ps -a | grep 'slaver1' | rev | cut -d ' ' -f 1 | rev` ] && echo "The container 「slaver1 」 has existed" || docker run -id --name slaver1 --hostname slaver1 -p 50070:50070 -p 8088:8088 oniontraveler/hadoop_container:19.5.4
 [ `docker ps -a | grep 'slaver2' | rev | cut -d ' ' -f 1 | rev` ] && echo "The container 「slaver2 」 has existed" || docker run -td --name slaver2 --hostname slaver2 oniontraveler/hadoop_container:19.5.4


#========================= (port explanation)
# -p 50070:50070  -> HDFS
# -p 8088:8088    -> YARN
# -p 8080:8080    -> Spark


#========================= (docker commands for entering into the container(master or slaver1))
# docker exec -it master /bin/bash
# docker exec -it slaver1 /bin/bash

