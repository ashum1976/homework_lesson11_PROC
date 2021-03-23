#!/usr/bin/env bash

# awk '{print "PID="$1,"COMMAND="$2, "STAT=","PPID="$4}'


#ls -d /proc/+([0-9])/ | sort --field-separator=/ -k 3 -g
            
#                ls -d /proc/+([0-9])/                       <---- Выводит имена каталогов, вместо их содержимого. Имена каталогов  - цифры.
 #               sort --field-separator=/ -k 3 -g      <---- Сортировка вывода, где разделитель полей "/"

                
# echo "С высоким приоритетом дисковых операций"
#echo "С низким приоритетом дисковых операций"
# Запускаем одновременно 2 команды с разным приоритетом

#time sudo ionice -c 1 -n 0  dd if=/dev/zero of=/tmp/test.img bs=2000 count=1M &  


#time sudo ionice -c 3 dd if=/dev/zero of=/tmp/test2.img bs=2000 count=1M &


time time sudo nice -n 19 tar -czf nice_low.tar.bz2 /usr/src/ &
time time sudo nice -n -20 tar -czf nice_higt.tar.bz2 /usr/src/ &
