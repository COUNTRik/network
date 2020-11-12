# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Удаляем маршрут по умолчанию от вагранта
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.1.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

# Перезапускаем сервис сети
systemctl restart network