# pksmall_infra

pksmall Infra repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/pksmall_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-08/pksmall_infra)

## Branches

### ansible-1
+ Создана новая ветка
+ Установлен ansible и развернута тестовая среда
+ Созданы все файлы для запуска ansinble и проверены в работе 
+ При удалении гит репозитария команда вывела следующее: 
```
appserver | CHANGED | rc=0 >>
```
  т.е. были проведены изменения  и директория успешно удалена.
+ Для задачи со * пришлось чуть модифицировать вывод команд в stage, чтобы получить не только 
  айпи инстанца приложения, но и базы данных. После чего написан скрипт изменяющий 2 переменных в
  файле invetory.json.
+ Так же можно воспользоваться модулем динамик инвентори для GCP. Пример в есть в коммите - *inventory.gcp.yml*.

###  terraform-2
+ Создана новая ветка
+ Создал packer-ом два новых образа для app и db
+ Добавил модульность в структуру и создал две директории состояния stage и prod
+ Создал backet из модуля
+ Перенес state файлы тераформа в backet
+ Добавил файлы для провижинга и переменную окружения для подключения к db

###  terraform-1
+ Создана новая ветка
+ Созданы файлы нужные для проект main.tf, output.tf, variables.tf terraform.tfvars.
+ Скрипты для развертывания перекочевали в директорию files.
+ Все создается и работает.
+ Добавил больше 1-го ключа ssh в инстанс.
+ Добавил глобальный ssh ключ и при этом удались все ключи, которые были глобально, оставив только 1,
  только что созданный.
+ Создан файл lb.tf с балансировщиком. Проблемы маштабируемости такого решения очевидны, всегда нужно
  при увелечении дергать файл конфига тераформа, лучше использовать темплейты для этого и описать состояние
  при каком увеличивать инстанты из темплейта.

###  packer-base

+ Создана новая ветка
+ Создана директори config-scripts и скрипты *.sh перенесены.
+ Перенесены  3 файла install_ruby.sh, install_mongodb.sh и  deploy.sh 
  в директорию packer/script
+ Создан файл packer/ubuntu16.json
+ Запущен и выполнен процесс создания нового образа в GCP
+ Создан файл variables.json  с переменнными и ubuntu16.json поправлен
  на использование онных.
+ Команда для запуска с переменными:
```bash
packer build -var-file=variables.json \
             -var 'gcp-proj-id=my-project-id' \
             -var 'src-img-fml=ubuntu-1604-lts' \
             -var 'mach-type=f1-micro' \ 
             ubuntu16.json
```
+ Создан файл immutable.json для полного разварачивания приложения в инстанте.
+ Добавлены скрипты deploy.sh - для установки приложения и gen_systemd.py - для
  запуска приложения через systemd в полной версии.
+ Создан скрипт config-scripts/create-redditvm.sh

###  cloud-testapp

testapp_IP = 35.246.157.104
testapp_port = 9292

+ Создан новая ветка
+ Создана директори *VPN и скрипты setupvpn.sh и *.ovpn перенесены.
+ Созданы 3 файла install_ruby.sh, install_mongodb.sh и  deploy.sh
+ Команда для запуска со starup_script:
```bash
gcloud compute instances create reddit-app \
        --boot-disk-size=10GB \
        --image-family ubuntu-1604-lts \ 
        --image-project=ubuntu-os-cloud \
        --machine-type=g1-small \
        --tags puma-server \
        --restart-on-failure \
        startup-script=./startup_test_app.sh
```
+ Команда для добавления правила в файрвол:
```bash
gcloud compute firewall-rules create puma-test-app \ 
        --network default \
        --action allow \
        --direction ingress \ 
        --rules tcp:9292 \
        --source-ranges 0.0.0.0/0 \ 
        --target-tags puma-server
```

### play travis

+ Создан новая ветка
+ Добавлен темплейт для заполнения при выполении ДЗ
+ Добавлен .travis.yml для работы с Trevis CI
+ Добавлен test.py для тестирование интеграции с Trevis CI
+ исправлен баг в test.py для безошибочного выполнения

### cloud-bastion

bastion_IP = 35.207.129.152 

someinternalhost_IP = 10.156.0.3

+ создана новая ветка
+ зарегестрирован новый аккаунт в GCP
+ созданы два инстанца с реальным IP и без него
+ описан процесс, как можно еще добраться до внутреннего хоста через ssh
+ создан VPN сервер на bastion
+ сохранена конфигурция для openvpn клиента
+ проверено подключение к внетренему хосту (someinternalhost)
+ настроен letsencrypt (https://vpn.dtgb.solutions)

#### ssh jump host

для возможности быстро попадать на внутрений хост можно использовать 
связку ssh с ключем -J

```bash
ssh -J user@host1:port user@host2:port
```

alias-ы можно прописать в *~/.ssh/config* файле по типу:
```
### Первый хост доступен на прямую - bastion 
Host bst
  HostName 35.207.129.152 
  IdentityFile ~/.ssh/appuser
  User appuser

### Второй хост через bastion - someinternalhost
Host smi
  HostName 10.156.0.3
  IdentityFile ~/.ssh/appuser
  Port 22
  User appuser
  ProxyCommand ssh -q -W %h:%p bst
```

и теперь можно смело конектится к *someinternalhost* с помощь короткой команды:
```bash
ssh smi
```
