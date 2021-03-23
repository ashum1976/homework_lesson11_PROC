#!/usr/bin/env bash

#Паралельный зпуск команд, для теста и проверки работы команды nice, предназначенной для запуска процессов с различными приоритетами исполнения
#'19' - наименьший приоритет, '-20' - наивысший приоритет_

time time sudo nice -n 10 tar -czf nice_low.tar.bz2 /usr/src/ &
time time sudo nice -n -10 tar -czf nice_higt.tar.bz2 /usr/src/ &
