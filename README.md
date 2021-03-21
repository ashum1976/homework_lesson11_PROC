

<<<<<<< HEAD
man proc
/proc/[pid]/stat - статус информация о процессах, отсюда её берёт ps
man kill - ман по сигналам
kill -l  -все возможгые сигналы:

    1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
    6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
    11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
    16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
    21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
    26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
    31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
    38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
    43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
    48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
    53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
    58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
    63) SIGRTMAX-1  64) SIGRTMAX


Namespaces (пространство имён) 

Утилиты: 

*   **unshare** <---- _запустить программу в новом пространстве имен (отделить от родительского)_
    Пример:
    
        unshare --fork --pid --mount-proc readlink /proc/self
        $ unshare --map-root-user --user sh -c whoami

*   **nsenter** <---- _запустить программу в чужом пространстве имен (войтив чужое пространство)_
*   **lsns**    <---- _просмотр текущих Namespaces_


Утилиты просмотра и управления  процессами, каталог "/proc"


**iotop             :** <----  _IO status
ps
top
pstree

---

**/proc/$pid/       :** <---- _Просмотреть все парамтры процессов по pid, а так же все параметры системы cpuinfo, version,  
    Пример:
    
        cwd - ссылка на текущий каталог процесса
        cmdline — содержит команду с параметрами с помощью которой был запущен процесс
        environ — переменные окружения, доступные для процесса
        maps, statm, и mem — информация о памяти процесса
        fd/ - директория со списком файловых дескрипторов
        exe - ссылка на исполняемый файл
        status - файл с детальной информацией о процессе
        stat - машиночитаемый файл с информацией о процессе

---
        
**lsof              :** <---- _Утилита, которая предназначена для вывода информации о том, какие файлы используются теми или иными процессами, пользователями._
<details> 
             <summary>Различные варианты запуска  утилиты lsof</summary>
    

    
**Пользователи**
    
        lsof -u username                    <---- Все открытые файлы для конкретного пользователя
        lsof -i -u^root                     <---- Исключение пользователя с использованием символа «^»
        lsof -i -u test                     <---- Какие файлы и команды использует пользователь test
        kill -9 `lsof -t -u test`           <---- Завершить все процессы пользователя test

**Сетевые соединения**

        lsof -i 4                           <---- Все соединение для протокола ipv4
        lsof -i TCP:port                    <---- Фильтр по протоколу и порту
        lsof -i TCP@127.0.0.1               <---- Фильтр по IP адресу, что запущенно на данном IP, по TCP протоколу
        lsof -i TCP:1-1024                  <---- Вывод открытых файлов диапазона портов TCP 1-1024
        lsof -i                             <---- Все интернет соединения
        lsof -i udp/tcp                     <---- Открытые файлы определенного протокола

**Файлы и директории**        

        lsof -p [PID]                       <---- Открытые файлы процесса по PID
        lsof -t [file-name]                 <---- каким процессом открыт файл
        lsof +D(d) /usr/lib/locale          <---- Посмотреть кто занимает директорию
        lsof -c [prog name]                 <---- выводит список файлов, отрытых процессами, выполняющими команды, название которых начинается строкой string[prog name]
</details>       

Ключи запуска программы:

-   опция **_–F_** которая позволяет показывать вывод не в виде таблицы, а в виде отдельных строк. Так же с помощью этой опции можно задавать какие именно строки будут выведены только те строки которые вас интересуют например командой **_-F pcn мы выведем только идентификатор процесса имя команды и имя файла_**
-   по умолчанию lsof комбинирует ключи как "ИЛИ" есть опция **–а** которая позволяет комбинировать опции как "И"
-   опция **_–R_** выводит дополнительный столбец в котором отображается информация об идентификаторе родительского процесса
-   сетевой фильтр для выводи информации по соединениям задаётся в следующем виде: **_-i [46][protocol][@hostname|ip-адресс][:service|port]_**
            
            lsof -i TCP@127.0.0.1   <---- Что запущено , по протоколу TCP на IP адресе 127.0.0.1
            
-   опция **_+L1_** которая показывает файлы которые были удалены но все ещё используются какой-то программой
-   опция **_+r_**, которая служит для периодического повторения запуска команды через заданный промежуток времени
            
            lsof +r 10 +d $(pwd)    <---- Кадые 10сек выводить информацию кто использует каталог, находясь в котором была запущена программа
        
<details> 
                <summary>Поля выводимые при вызове утилиты lsof</summary>
                
        PID, USER, FD, TYPE, Command        <---- Выводимые поля
        
            Поле "FD" — обозначает дескриптор файла и принимает следующие значения как:

                    cwd — текущий рабочий каталог
                    rtd — корневой каталог
                    txt — текст программы (код и данные)
                    mem — файл памяти
                    Кроме того, в столбцах FD такие номера, как "1u", являются фактическим дескриптором файла, а за ним следует один из флагов u, r, w как режим доступа:
                        r — доступа для чтения.
                        w — доступа для записи.
                        u — чтения и записи.
                        
            Поле "TYPE" — файлов и их идентификация:

                    DIR — директория
                    REG — обычный файл
                    CHR — специальный символьный файл.
                    FIFO — First In First Out
         
         

</details>                    





---


**fuser             :** <---- _Показывает какие процессы используют указанные файлы, сокеты или файловые системы. Можно сразу убить процессы использующие файл или наступившие на файл_
    Пример:
                    
        fuser -km /home         <---- Прибить процессы использующие файловую систему "/home"
        fuser -v /mnt           <---- посмотреть все процессы использующие директорию
        fuser -v -n tcp 80      <---- Все процессы использующие 80й порт
        fuser -i -k 123/tcp     <---- убить все процессы слушающие порт
        fuser -v -m example.txt <---- найти процессы кто использует файловую систему где расположен файл


=======


man proc  секция        proc/[pid]/stat где ковыряется ps
>>>>>>> 93929eb9f64ddcb9d2d9561611ded94e8121e401
