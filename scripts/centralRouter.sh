# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Установим пакеты
yum install -y mc vim mtr

# Включаем прохождение пакетов между сетевыми интерфейсами
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Удаляем маршрут по умолчанию от вагранта и устанавливаем нужный нам маршрут
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

# Установим пакеты
yum install -y mc vim

# Перезапускаем сервис сети
reboot

# ip route add 192.168.1.0/24 via 192.168.3.3 dev eth2
# ip route add 192.168.2.0/24 via 192.168.3.2 dev eth2
