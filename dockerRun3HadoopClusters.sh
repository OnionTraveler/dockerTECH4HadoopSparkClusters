#!/bin/bash
docker build -f ./myDockerfiles/onionfile -t oniontraveler/hadoop_container:19.5.4 .

docker run -itd --name master --hostname master oniontraveler/hadoop_container:19.5.4
docker run -id --name slaver1 --hostname slaver1 oniontraveler/hadoop_container:19.5.4
docker run -td --name slaver2 --hostname slaver2 oniontraveler/hadoop_container:19.5.4


#========================= (docker commands for entering into the container(master or slaver1))
# docker exec -it master /bin/bash
# docker exec -it slaver1 /bin/bash
