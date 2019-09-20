# pksmall_infra

pksmall Infra repository


## Branches

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
