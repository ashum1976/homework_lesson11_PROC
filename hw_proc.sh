#!/usr/bin/env bash

clk_tck=$(getconf CLK_TCK)
#Заносим в переменную все значения процессов по их PID из каталога proc 
proc_pid=$(ls -1 /proc/ | egrep '^[0-9]+$' | sort -g)

#proc_pid1=$(ls -d /proc/+([0-9]) | sort --field-separator="/" -k 3 -g)
#echo $proc_pid1
#Задаём массив для хранения значений PID
array_pids=( $(echo ${proc_pid}) )

#Подготавливаем массив array_pts для замены в поле TTY, числового значения 348(16-44), на значение pts/"$"
pts_count=0
for (( i=34816; i<=34844; i++ ))
    do
        array_pts[$i]=$(echo "pts/$pts_count")
        (( pts_count++ ))
done

#Подготавливаем массив array_tty для замены в поле TTY, числового значения, на значение tty"$"
tty_count=0
for (( i=1025; i<=1090; i++ ))
    do
        array_tty[$i]=$(echo "tty${tty_count}")
        (( tty_count++ ))
    done

(
i=0
echo "PID|TTY|STAT|PPID|TIME|COMMAND";
while (( $i < ${#array_pids[@]} ))
        do
           if [[ -d $( echo /proc/${array_pids[$i]}) ]] 
            then
           # echo ${array_pids[$i]}
           # awk '{print "PID="$1,"COMMAND="$2, "STAT="$3,"PPID="$4}' /proc/$(echo ${array_pids[$i]})/stat
            #awk   '{print $1,"  " $7,"  "$3,"  "$4,"  "$2}' /proc/$(echo ${array_pids[$i]})/stat
            pid=$(awk '{print $1}' /proc/$(echo ${array_pids[$i]})/stat)
            tty=$(awk '{print $7}' /proc/$(echo ${array_pids[$i]})/stat)
            stat=$(awk '{print $3}' /proc/$(echo ${array_pids[$i]})/stat)
            ppid=$(awk '{print $4}' /proc/$(echo ${array_pids[$i]})/stat)
            comm=$(awk '{print $2}' /proc/$(echo ${array_pids[$i]})/stat)
            utime=$(awk '{print $14}' /proc/$(echo ${array_pids[$i]})/stat)
            stime=$(awk '{print $15}' /proc/$(echo ${array_pids[$i]})/stat)
            uptime=$(awk '{print $1}' /proc/uptime)
            vtime=$(( utime + stime ))
            time=$(date -d@$(( vtime / clk_tck  )) +%M:%S)
                    if [[ $(echo $tty) -eq 0  ]]
                        then 
                                tty='?'
                                
                        elif [[ $(echo $tty) -le 34844 && $(echo $tty) -ge 34816 ]]
                                then 
                                    tty=$(echo ${array_pts[$tty]})
                                    
                        elif [[ $(echo $tty) -le 1090 && $(echo $tty) -ge 1025 ]]
                                then 
                                    tty=$(echo ${array_tty[$tty]})
                                    
                    fi
            
            
            
            echo "${pid}|${tty}|${stat}|${ppid}|${time}|${comm}"
             fi
             (( i++ ))
done
) | column -t -s "|"

#column - формирование вывода, в виде таблицы с разбивкой полей по "|"
