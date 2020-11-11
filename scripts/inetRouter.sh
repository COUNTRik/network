# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Перезапускаем сеть
service network restart

# Включаем прохождение пакетов между сетевыми интерфейсами
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf

# Перезапускаем сеть
service network restart

# Добавим правило iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save

# Усановим пакеты
# yum install -y epel-release
yum install -y vim mc