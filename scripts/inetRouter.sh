#!/usr/bin/env bash

# Включаем прохождение пакетов между сетевыми интерфейсами
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Добавим правило iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save

# Перезапускаем сеть
service network restart

# Добавляем маршрут к нашим локальным роутерам
# ip route add 192.168.0.0/22 via 192.168.255.2 dev eth1
# cat /proc/sys/net/ipv4/ip_forward
