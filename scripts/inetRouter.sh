# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Включаем прохождение пакетов между сетевыми интерфейсами
sysctl net.ipv4.conf.all.forwarding=1

# Добавим правило iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Добавим маршрут для подсетей central, office1, office2
ip route add 192.168.0.0/22 dev eth1 via 192.168.255.2