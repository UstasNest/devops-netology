# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
- Следует использовать версию [Terraform](https://www.terraform.io/) не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

#### Решение
1. создал s3 bucket в yandex cloud с помощью teraform:
[terraform s3](./terraform/s3)
```
export YC_TOKEN=y0_Ag*********************************
terraform init
terraform apply
```
2. инициализировал backend для инфраструктуры
```
export ACCESS_KEY=YCAJER898OJP68YRQW1RC27O_
export SECRET_KEY=YCP6UK************
terraform init -reconfigure -backend-config="access_key=$ACCESS_KEY" -backend-conf
```
3. создал инфраструктуру [terraform](./terraform/main):
```
terraform init
terraform apply
```
4. на выходе файл с адресами серверов: [./ansible/group_vars/all/ip.yml](./ansible/group_vars/all/ip.yml)

![img_21.png](img_21.png)
![img_22.png](img_22.png)
---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

#### Решение
1. установка и настройка хостов и всех приложений происходит с помощью ansible: [ansible](./ansible/).
В kubespray дополнительно включил установку ingress-nginx, argocd, также плейбук меняет параметры в настройках приложений, можно ставить все по шагам используя теги: step1:step6
```
ansible-playbook -i inventory/prod.yml site.yml --tag step1
ansible-playbook -i inventory/prod.yml site.yml --tag step2
ansible-playbook -i inventory/prod.yml site.yml --tag step3
```
2. После установки на мастер ноде, ансибл копирует .kube/config на локальную машину, результат проверки:
```
vagrant@master:~$ kubectl get pod --all-namespaces
NAMESPACE       NAME                                                READY   STATUS    RESTARTS        AGE
argocd          argocd-application-controller-0                     1/1     Running   0               19h
argocd          argocd-applicationset-controller-568754c579-9tjbz   1/1     Running   0               19h
argocd          argocd-dex-server-756f8676-tndnt                    1/1     Running   0               19h
argocd          argocd-notifications-controller-5548b96954-d2n7j    1/1     Running   0               19h
argocd          argocd-redis-69d46564c7-98zqd                       1/1     Running   0               19h
argocd          argocd-repo-server-5477864cb5-jdkfh                 1/1     Running   0               19h
argocd          argocd-server-5d44b8945f-bhthm                      1/1     Running   0               19h
ingress-nginx   ingress-nginx-controller-7dltm                      1/1     Running   0               19h
ingress-nginx   ingress-nginx-controller-spbcp                      1/1     Running   0               19h
kube-system     calico-kube-controllers-6c7b7dc5d8-npfvx            1/1     Running   0               19h
kube-system     calico-node-4d7kg                                   1/1     Running   0               19h
kube-system     calico-node-rt589                                   1/1     Running   0               19h
kube-system     calico-node-t2fpf                                   1/1     Running   0               19h
kube-system     coredns-69db55dd76-np7m5                            1/1     Running   0               19h
kube-system     coredns-69db55dd76-rhgsd                            1/1     Running   0               19h
kube-system     dns-autoscaler-6f4b597d8c-m6dz5                     1/1     Running   0               19h
kube-system     kube-apiserver-master                               1/1     Running   1               19h
kube-system     kube-controller-manager-master                      1/1     Running   6 (6h18m ago)   19h
kube-system     kube-proxy-h998t                                    1/1     Running   0               19h
kube-system     kube-proxy-swcbt                                    1/1     Running   0               19h
kube-system     kube-proxy-vrfsp                                    1/1     Running   0               19h
kube-system     kube-scheduler-master                               1/1     Running   2 (17h ago)     19h
kube-system     nginx-proxy-node1                                   1/1     Running   0               19h
kube-system     nginx-proxy-node2                                   1/1     Running   0               19h
kube-system     nodelocaldns-fc5c5                                  1/1     Running   0               19h
kube-system     nodelocaldns-nstql                                  1/1     Running   0               19h
kube-system     nodelocaldns-vtc4l                                  1/1     Running   0               19h
```

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

#### Решение
1. Тестовое приложение тут: [myapp](https://github.com/UstasNest/app)
2. ![img.png](img.png)
---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

#### Решение
- деплой kube-prometeus происходит так же с помощью [ансибл](./ansible) с тегом --tag step4
- helm chart myapp лежит [тут](./myapp/) манифесты qbec [тут](./qbec/myapp) 
- для установки atlantis поставил nfs server, ставится плейбуком с тегом --tag step5, далее atlantis c тегом --tag step6
- в папке [manifests](./manifests) лежат манифесты для настроки сервиса и сетевых настроек grafana,  деплоймент приложения, ингресс для доступа к приложению снаружи. Также конфигмап для настройки atlantis-a и ключи для подключения github webhook, либо github app.

![img_5.png](img_5.png)
![img_6.png](img_6.png)
![img_7.png](img_7.png)
![img_8.png](img_8.png)
![img_9.png](img_9.png)
![img_3.png](img_3.png)

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

#### Решение
Настроил CI на github [манифесты тут](./cicd) Установил Argo CD [конфигмап тут](./manifests), настроил автоматический деплой, загружена версия с тегом 1.1.4
при комите в репозиторий происходит сборка и отправка в докерхаб. Обновления приложения не присходит
![img_11.png](img_11.png)
![img_12.png](img_12.png)
![img_14.png](img_14.png)
![img_10.png](img_10.png)
![img_13.png](img_13.png)

делаю новый комит, и тег на 1.1.5
![img_15.png](img_15.png)
все собралось и задеплоилось:
![img_16.png](img_16.png)
![img_17.png](img_17.png)
![img_18.png](img_18.png)
![img_19.png](img_19.png)
![img_20.png](img_20.png)
---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
