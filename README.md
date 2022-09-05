#devops-netology
5.
![img.png](img.png)
6. 
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end
8. 
HISTSIZE, 862 line   
ignoreboth is shorthand for ignorespace & ignoredups  
9. Brace Expansion, 921 line    
10.  touch file{1..100000}     
300000 не создается -bash: /usr/bin/touch: Argument list too long  
Ограничение системы
11. вернет true, 0, т.к. /tmp существует   
12. 
mkdir /tmp/new_path_directory  
cp /bin/bash /tmp/new_path_directory/  
echo $PATH  
export PATH=/tmp/new_path_directory:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/loc
al/games:/snap/bin  
type -a bash   
vagrant@vagrant:~$ type -a bash  
bash is /tmp/new_path_directory/bash  
bash is /usr/bin/bash  
bash is /bin/bash  

13. at выполняется в определенное время batch когда позволяет загрузка системы  
14. vagrant halt  

3.2. Работа в терминале, лекция 2

1. cd внутрення команда, в теории и внешней могла бы быть,   
тогда чтобы сменить каталог нужно видимо вызвать bash в новом каталоге ну либо как то   
указатель поменять на текущий каталог, в целом было бы сложнее  
2. ключ -с, grep <some_string> <some_file> -с  
3. pstree -p | more, systemd  
4. ls -l  2>/dev/pts/1  
5.  
cat >> test1  
something  
ctrl+z  
cat < test1 > test2  
cat test2   
something   
6.  получится, надо режим перключить и залогиниться в tty и сделать перенаправление вывода  
7. создается файловый дескрпитор, туда направляется stdout затем выводим в дескриптор строку,   
она отображается в текущем pts
8.
эмуляция вывода без ошибок на PTY: ls -l 5>&2 2>&1 1>&5 | cat test  
эмуляция ошибки и обработки через pipe : ls -l /root 5>&2 2>&1 1>&5 | cat test  
9.  выводит перменные окружения, тоже самое выведет команда env  
10.  /proc/PID/cmdline содержит информацию о процессе запущенном   
из коммандной строки, аргументы отображаются с разделением нуль байтами  
/proc/PID/exe содержит символическую ссылку на запущенную программу  
11. 4.2  
12. ssh выполняет команду удаленно без создания псевдотерминала, потому такой ответ,   
псевдотерминал нужно создавать принудительно, ключ -t  
13. установил sudo apt install reptyl включил тут /etc/sysctl.d/10-ptrace.conf, дает возможность перехватить  
14. tee одновременно выводит в файл и в stdout, в первом случае перенаправление работает под обычным пользователем,  
sudo на него не распространяется. Во втором случае права даются на tee, поэтому все работает

  
  
