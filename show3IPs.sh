#/bin/bash

#========================= docker inspect
 [ -e ./ip-inspect.txt ] && echo "The 「ip-inspect.txt」 file has existed" || touch ./ip-inspect.txt
 [ `cat ./ip-inspect.txt | grep 'master' | cut -d ' ' -f 2` ] && echo "The 「master」 in ip-inspect.txt has existed！" || echo "`docker inspect  --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" master` master" >> ./ip-inspect.txt
 [ `cat ./ip-inspect.txt | grep 'slaver1' | cut -d ' ' -f 2` ] && echo "The 「slaver1」 in ip-inspect.txt has existed！" || echo "`docker inspect  --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver1` slaver1" >> ./ip-inspect.txt
 [ `cat ./ip-inspect.txt | grep 'slaver2' | cut -d ' ' -f 2` ] && echo "The 「slaver2」 in ./ip-inspect.txt has existed！" || echo "`docker inspect  --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" slaver2` slaver2" >> ./ip-inspect.txt

echo " "
echo =======docker inspect=======
cat ip-inspect.txt

#========================= (siao sheng miè ji)
rm -f ./ip-inspect.txt

