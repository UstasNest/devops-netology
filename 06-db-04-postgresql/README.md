# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
![img.png](img.png)
Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
postgres=# \l  
                                 List of databases  
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges  
-----------+----------+----------+------------+------------+-----------------------  
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |  
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +  
           |          |          |            |            | postgres=CTc/postgres  
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +  
           |          |          |            |            | postgres=CTc/postgres  
(3 rows)  
- подключения к БД
postgres=# \c postgres  
You are now connected to database "postgres" as user "postgres".  
- вывода списка таблиц
postgres=# \dt  
Did not find any relations.  
- вывода описания содержимого таблиц
postgres-# \d pg_am  
               Table "pg_catalog.pg_am"  
  Column   |  Type   | Collation | Nullable | Default  
-----------+---------+-----------+----------+---------  
 oid       | oid     |           | not null |  
 amname    | name    |           | not null |  
 amhandler | regproc |           | not null |  
 amtype    | "char"  |           | not null |  
Indexes:  
    "pg_am_name_index" UNIQUE, btree (amname)  
    "pg_am_oid_index" UNIQUE, btree (oid)  
- выхода из psql
postgres-# \q  
root@ec4ae267df3f:/#  
  
## Задача 2

Используя `psql` создайте БД `test_database`.
postgres=# CREATE DATABASE test_database;  
CREATE DATABASE  
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
root@ec4ae267df3f:/# psql -U postgres test_database < /data/backup/postgres/test_dump.sql  
SET  
SET  
SET  
SET  
SET  
 set_config  
------------  
  
(1 row)  
  
SET  
SET  
SET  
SET  
SET  
SET  
CREATE TABLE  
ALTER TABLE  
CREATE SEQUENCE  
ALTER TABLE  
ALTER SEQUENCE  
ALTER TABLE  
COPY 8   
 setval  
--------  
      8  
(1 row)  

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
![img_1.png](img_1.png)  
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
![img_2.png](img_2.png)  
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
test_database=# BEGIN;  
BEGIN  
test_database=*# ALTER TABLE orders RENAME TO orders_old;  
ALTER TABLE  
test_database=*# CREATE TABLE orders AS table orders_old WITH NO DATA;  
CREATE TABLE AS  
test_database=*# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);  
CREATE TABLE  
test_database=*# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);  
CREATE TABLE  
test_database=*# CREATE RULE orders_1_ins AS ON INSERT TO orders WHERE (price > 499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);  
CREATE RULE  
test_database=*# CREATE RULE orders_2_ins AS ON INSERT TO orders WHERE (price <= 499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);  
CREATE RULE  
test_database=*# INSERT INTO orders SELECT * FROM orders_old;  
INSERT 0 0  
test_database=*# COMMIT;  
COMMIT  
![img_3.png](img_3.png)  
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Да, создать таблицу с параметром PARTITION BY и таблицы orders_1, orders_2 c соответствующими ограничениями:  
CREATE TABLE orders (id integer NOT NULL, title character varying(80) NOT NULL, price integer DEFAULT 0) PARTITION BY RANGE (price);
CREATE TABLE orders_1 PARTITION OF orders FOR VALUES GREATER THAN ('499');  
CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM ('0') TO ('499');  

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.  
  
root@ec4ae267df3f:/# pg_dump test_database -U postgres -v -f /data/backup/postgres/test_database.sql  
  
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?  
добавить UNIQUE:    
CREATE TABLE public.orders (  
    id integer NOT NULL,  
    title character varying(80) NOT NULL UNIQUE,  
    price integer DEFAULT 0  
);  
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---