#!/usr/bin/env bash

#Генерим test файл для работы других скриптов проверки
dd if=/dev/urandom of=/vagrant/test bs=512K count=125

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
#Шапка вывода данных в скрипте, разбивка по полям с разделителем "|". Для дальнейшего формирования таблицы вывода.  
echo "PID|TTY|STAT|PPID|TIME|COMMAND"; 

#Проход с помощью цикла по сформированному массиву PID из каталога proc
while (( $i < ${#array_pids[@]} ))
        do
           if [[ -d $( echo /proc/${array_pids[$i]}) ]] 
            then
            #Формируем список переменных для получения нужных полей в выводе скрипта.
            pid=$(awk '{print $1}' /proc/$(echo ${array_pids[$i]})/stat)
            tty=$(awk '{print $7}' /proc/$(echo ${array_pids[$i]})/stat)
            stat=$(awk '{print $3}' /proc/$(echo ${array_pids[$i]})/stat)
            ppid=$(awk '{print $4}' /proc/$(echo ${array_pids[$i]})/stat)
            comm=$(awk '{print $2}' /proc/$(echo ${array_pids[$i]})/stat)
            
            #Преобразование поля TIME в выводе скрипта, должно отображаться время выполнения процессов на CPU. Данные о том как это поле формиируется были взяты с https://stackoverflow.com/questions/16726779/how-do-i-get-the-total-cpu-usage-of-an-application-from-proc-pid-stat
            utime=$(awk '{print $14}' /proc/$(echo ${array_pids[$i]})/stat)
            stime=$(awk '{print $15}' /proc/$(echo ${array_pids[$i]})/stat)
            uptime=$(awk '{print $1}' /proc/uptime)
            vtime=$(( utime + stime ))
            time=$(date -d@$(( vtime / clk_tck  )) +%M:%S) #<---- Результирующее поле, содержащее время в формате (Min:Sec), если нужно ещё и сасы, то добавиить в вывод ещё одно значение (%H)
            #/
            #Делаем замену в выводе поля TTY где значения из файла stat  выводятся в цифровом виде, преобразуем в вид, как в при выводе программы ps ax.
            #Используютяся ранее сформированные массивы array_pts и array_tty
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
