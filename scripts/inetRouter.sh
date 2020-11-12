# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Установим пакеты
yum install -y mc vim

# Включаем прохождение пакетов между сетевыми интерфейсами
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf

# Добавим правило iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save

# Перезапускаем сеть
service network restart
