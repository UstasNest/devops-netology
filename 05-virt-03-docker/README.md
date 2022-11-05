1.    
root@server1:~# docker run -d -p 8080:80 --name nginx rmulyukov/nginx  
6b8e23d2e52fe7aae65eafda28e07ce47aec8d394a5b5ccd59bc36f598d48ef8
root@server1:~# docker ps  
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                                   NAMES
6b8e23d2e52f   rmulyukov/nginx   "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx   
root@server1:~# curl 172.17.0.1:8080  
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>

https://hub.docker.com/r/rmulyukov/nginx   

2.  
Высоконагруженное монолитное java веб-приложение;
Физический сервер, либо ВМ, позволит выделять больше ресурсов для приложения

Nodejs веб-приложение;  
docker контейнер, позволит быстро реагировать на нагрузки, разворачивать больше контенеров, контейнеры независимы друг от друга и приложения не будут влиять на хостовую систему

Мобильное приложение c версиями для Android и iOS;  
IOS Требует МакОС, поэтому физический сервер, под Android можно использовать Docker

Шина данных на базе Apache Kafka;  
учитывая что это брокер сообщений Docker подойдет для масштабирования   

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;  
Docker подойдет с точки зрения быстроты масштабирования

Мониторинг-стек на базе Prometheus и Grafana;
Docker подойдет с точки зрения быстроты масштабирования  


MongoDB, как основное хранилище данных для java-приложения;  
виртуальная машина, т.к. основное хранилище

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.  
виртуальная машина, довольно ресурсоемкая система, но в то же время масштабируемость не так критична
  
3.  
root@server1:~# mkdir data  
root@server1:~# docker run -it -d -v ~/data:/data --name centos centos 
Unable to find image 'centos:latest' locally  
latest: Pulling from library/centos  
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
0f3e3cbea1a7cdabe9e9f7d2b9f4ea50369b090fd0e971007e03180d881bce2f  
  
root@server1:~/data# docker run -it -d -v ~/data:/data --name debian debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
17c9e6141fdb: Pull complete
Digest: sha256:bfe6615d017d1eebe19f349669de58cda36c668ef916e618be78071513c690e5
Status: Downloaded newer image for debian:latest
05cb1a4cc2bbf7c53290f87b9073a0c6431d7a56682cbc4e54204afeaa2b2fa4   

root@server1:~/data# docker exec -it centos bash  
[root@0f3e3cbea1a7 /]# cat > /data/centos_ex  
centos  
^Z  
[1]+  Stopped                 cat > /data/centos_ex  
[root@0f3e3cbea1a7 /]# exit  
exit  
There are stopped jobs.  
[root@0f3e3cbea1a7 /]# exit  
exit   

root@server1:~/data# cat > host_ex  
host  
^Z  
[1]+  Stopped                 cat > host_ex   

root@server1:~/data# docker exec -it debian bash  
root@05cb1a4cc2bb:/# ls -l /data  
total 8  
-rw-r--r-- 1 root root 7 Nov  5 18:38 centos_ex  
-rw-r--r-- 1 root root 5 Nov  5 18:41 host_ex  
root@05cb1a4cc2bb:/#  
