# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Включаем прохождение пакетов между сетевыми интерфейсами
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Удаляем маршрут по умолчанию от вагранта
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0

# Перезапускаем сервис сети
systemctl restart network