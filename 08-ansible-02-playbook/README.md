# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
vagrant@server1:~/08-ansible-02-playbook/playbook$ ansible-lint site.yml
vagrant@server1:~/08-ansible-02-playbook/playbook$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
``` bash
vagrant@server1:~/08-ansible-02-playbook/playbook$ sudo ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ***********************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [clickhouse-vector]

TASK [Get clickhouse distrib] *******************************************************************************************************************
ok: [clickhouse-vector] => (item=clickhouse-client)
ok: [clickhouse-vector] => (item=clickhouse-server)
failed: [clickhouse-vector] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************
ok: [clickhouse-vector]

TASK [Install clickhouse packages] **************************************************************************************************************
ok: [clickhouse-vector]

TASK [Flush handlers] ***************************************************************************************************************************

TASK [Create database] **************************************************************************************************************************
changed: [clickhouse-vector]

PLAY [Install Vector] ***************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [clickhouse-vector]

TASK [Get Vector package] ***********************************************************************************************************************
changed: [clickhouse-vector]

TASK [Install vector package] *******************************************************************************************************************
changed: [clickhouse-vector]

TASK [Change vector systemd unit] ***************************************************************************************************************
--- before: /usr/lib/systemd/system/vector.service
+++ after: /root/.ansible/tmp/ansible-local-98355lsr09_7g/tmp7938rjzo/vector.service.j2
@@ -1,19 +1,14 @@
 [Unit]
-Description=Vector
+Description=Vector service
 Documentation=https://vector.dev
 After=network-online.target
 Requires=network-online.target

 [Service]
-User=vector
-Group=vector
-ExecStartPre=/usr/bin/vector validate
-ExecStart=/usr/bin/vector
-ExecReload=/usr/bin/vector validate
-ExecReload=/bin/kill -HUP $MAINPID
-Restart=no
-AmbientCapabilities=CAP_NET_BIND_SERVICE
-EnvironmentFile=-/etc/default/vector
+User= root
+Group= 0
+ExecStart=/usr/bin/vector --config /etc/vector/vector.yml
+Restart=always

 [Install]
 WantedBy=multi-user.target

changed: [clickhouse-vector]

TASK [Apply vector template] ********************************************************************************************************************
--- before
+++ after: /root/.ansible/tmp/ansible-local-98355lsr09_7g/tmpx0_5ig7b/vector.yml.j2
@@ -0,0 +1,16 @@
+---
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://127.0.0.1:8123
+        healthcheck: true
+        inputs:
+        - demo_logs
+        skip_unknown_fields: true
+        table: vector_table
+        type: clickhouse
+sources:
+    demo_logs:
+        format: syslog
+        type: demo_logs

changed: [clickhouse-vector]

RUNNING HANDLER [Start Vector service] **********************************************************************************************************
changed: [clickhouse-vector]

PLAY RECAP **************************************************************************************************************************************
clickhouse-vector          : ok=10   changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0

```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.  

   9.1 Плейбук предназначен для установки clickhouse и vector в docker контейнер на базе centos clickhouse-vector, указано все в в inventory.  
   В папке group_vars перечислены переменные:  
   - clickhouse_version версия кликхауса  
   - clickhouse_packages пакеты для скачивания  
   - vector_version версия вектор  
   - vector_config_dir каталог для установки  
   - vector_config указаны конфигурация вектор-а, какие брать входные данные - тестовые и параметры подключения к БД кликхаус.    

    9.2 В папке inventory в файле prod указаны группы и хост clickhouse-vector  для установки соответствующих сервисов.  

    9.3 В папке templates:  
   - vector.service.j2 шаблон для настройки службы vector  
   - vector.yml.j2 используется для настройки конфига vector, указана переменная где содержится конфигурация и что ее надо преобразовать в yml  

    9.4 site.yml
   - указаны теги clickhouse, vector используется чтобы можно было запускать отдельные задачи, например при отладке, содержит 2 play.  

    9.4.1 Install Clickhouse применяется на группу хостов clickhouse, объявляем handler для запуска clickhouse-server:  

    задачи:  
   - Get clickhouse distrib получение дистрибутивных пакетов и перехват ошибки rescue если пакета нет  
   - Install clickhouse packages установка полученных пакетов, в notify указываем что требуется запуск сервера
   - Flush handlers принудительно применяем notify, чтобы сервер сейчас запустился иначе 
   - следующие задачи будут завершены с ошибкой.   
   - Create database создаем БД logs  

    9.4.2. Install Vector применяется на группу хостов vector, объявляем handler для запуска vector:  

    задачи:  
   - Get Vector package скачиваем дистрибутив в локальную папку  
   - Install vector package устанвливаем  
   - Change vector systemd unit изменяеем по шаблону файл vector.service устанваливаем пользователя и права  
   - Apply vector template устанавливаем конфигурационный файл используя шаблон, запускаем валидацию, после этого указываю handler для запуска сервера

10.Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
