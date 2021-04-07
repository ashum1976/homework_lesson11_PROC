#!/usr/bin/env bash

#Паралельный зпуск команд, для теста и проверки работы команды nice, предназначенной для запуска процессов с различными приоритетами исполнения
#'19' - наименьший приоритет, '-20' - наивысший приоритет_
#Если несколько ядер, то для теста, запустим обе задачи на одном ядре
#Исходя из тестов при значениях 0 и -5 разница выполнения на процессоре составляет 25% на 75%



if [[ ! -f /vagrant/test ]]
    then
            dd if=/dev/urandom of=/vagrant/test bs=512K count=125 > /dev/null && time taskset -c 0 xz -z -c -9  /vagrant/test > /dev/null && echo  -e "\e[31m nice 0 команда завершена !\e[0m" &
            time taskset -c -5 nice -n -5 xz -z -c -9  /vagrant/test > /dev/null  &&  echo  -e "\e[31m nice -5 команда завершена !\e[0m" &
    else
            time taskset -c 0 xz -z -c -9  /vagrant/test > /dev/null && echo  -e "\e[31m nice 0 команда завершена !\e[0m" &
            time taskset -c 0 nice -n -5 xz -z -c -9  /vagrant/test > /dev/null  &&  echo  -e "\e[31m nice -5 команда завершена !\e[0m" &
fi
