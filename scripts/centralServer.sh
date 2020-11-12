# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Установим пакеты
yum install -y mc vim mtr

# Удаляем маршрут по умолчанию от вагранта и устанавливаем нужный нам маршрут
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

# Перезапускаем сервис сети
reboot