Плейбук предназначен для установки clickhouse, vector и lighthouse.  

в папке group_vars перечислены переменные   

clickhouse_version версия кликхауса  
clickhouse_packages пакеты для скачивания  
lighthouse_url репозиторий с лайтхаусом  
lighthouse_dir директория для установки лайтхаус  
lighthouse_nginx_user пользователь для Web сервера nginx  
vector_version версия вектор  
vector_config_dir каталог для установки  
vector_config указаны конфигурация вектор-а, какие брать входные данные - тестовые и параметры подключения к БД кликхаус  

в папке inventory в файле prod указаны группы и хосты clickhouse-01, vector-01 и lighthouse-01 с адресами для установки соответствующих сервисов  

в папке templates  
lighthouse_nginx.conf.j2 шаблон для настройки nginx чтобы работал с lighthouse, указываем порт, root каталог и первую страницу  
nginx.conf.j2 шаблон для настройки nginx укахываем пользователя и    
vector.service.j2 шаблон для настройки службы vector  
vector.yml.j2 используется для настройки конфига vector, указана переменная где содержится конфигурация и что ее надо преобразовать в yml  

site.yml  
указаны теги clickhouse, vector, nginx, lighthouse используется чтобы можно было запускать отдельные задачи, например при отладке   
содержит 3 play.  
1.Install Clickhouse применяется на группу хостов clickhouse, объявляем handler для запуска clickhouse-server  
задачи:   
Get clickhouse distrib получение дистрибутивных пакетов и перехват ошибки rescue если пакета нет   
Install clickhouse packages установка полученных пакетов, в notify указываем что требуется запуск сервера  
Flush handlers принудительно применяем notify, чтобы сервер сейчас запустился иначе следующие задачи будут завершены с ошибкой  
Create database создаем БД logs  
2. Install Vector применяется на группу хостов vector, объявляем handler для запуска vector  
задачи:  
Get Vector package скачиваем дистрибутив в локальную папку  
Install vector package устанвливаем   
Change vector systemd unit изменяеем по шаблону файл vector.service устанваливаем пользователя и права  
Apply vector template устанавливаем конфигурационный файл используя шаблон, запускаем валидацию, после этого указываем handler для запуска сервера  
2. Install lighthouse применяется на группу хостов lighthouse, объявляем handler для запуска nginx  
задачи:  
Install git устанавливаем git  
install EPEL repo устанавливаем EPEL repo т.к. в centos нет nginx  
Install nginx устанавливаем nginx  
Lighthouse apply nginx config применяем шаблон и устнавливаем конфигурацию nginx  
Lighthouse clone repository клонируем репозиторий lighthouse  
Lighthouse apply config устанавливаем конфигурацию nginx для lighthouse,  вызываем handler  


