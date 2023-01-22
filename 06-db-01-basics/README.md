1.   
Для электронных чеков  в json виде можно использовать NoSQL БД, для хранения в виде документов.  
Для логистической компании, нахождение складов и автодорог, можно использвоать графовые БД позволяет хранить атрибуты для выбора оптимального маршрута.    
Для хранения генеалогического дерева можно использовать сетевые БД, т.к. у каждого потомка будет 2 родителя, т.е. сетевой узел может иметиь отношения с несколькими объектами.      
Для организации кэша идентификаторов с определенным временем жизни для аутентификации можно использовать БД ключ-значение, поддерживает TTL.    
Для интернет магазина для поддержки отношений клиент-покупка можно использовать реляционные БД.
  
2.  
Данные записываются на все узлы с задержкой до часа (асинхронная запись) отсутствует консистентность - AP.
PA/EL, Если система разделена то приоритет AP, если не разделена то приоритет L.  
При сетевых сбоях, система может разделиться на 2 раздельных кластера, присутствует С и доступность А - АС.  
PС/EC при разделении С, т.е. PС, если не разделена то С.      
Система может не прислать корректный ответ или сбросить соединение, нет доступности, т.е. - PC  
PC/EC если система разделена то нет А, если не раздлена то С

3.  
В одной системе не могут сочетаться BASE и ACID принципы, т.к принципы противоположны и цели разные, первый доступность, второй надежность.  

4. 
Redis, БД c механизмом Pub/Sub.  Недостатки: 
 - могут быть проблемы с задержкой передаваемых сообщений  
 - требователен к памяти, нужно тестировать на целостность чтобы избежать критического сбоя  
 - современные версии достаточно надежны но могут быть критические сбои, помочь разобраться с ними могут разработчики системы при наличии дампа ошибок  
 - теряются сообщения в случае отсутствия подписчика  