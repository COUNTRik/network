# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Включаем прохождение пакетов между сетевыми интерфейсами
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Удаляем маршрут по умолчанию от вагранта и устанавливаем нужный нам маршрут
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1


# Перезапускаем сервис сети
systemctl restart network

# Добавляем маршрут по умолчанию через inetRouter
# ip route add default via 192.168.255.1 dev eth1

# # Добавим маршрут для подсети offece1
# ip route add 192.168.2.0/24 dev eth2 via 192.168.2.2

# # Добавим маршрут для подсети offece2
# ip route add 192.168.1.0/24 dev eth3 via 192.168.1.2

# Устанавливаем необходимые пакеты
yum install -y mtr vim mc

# Перезапускаем сервис сети
systemctl restart network