#!/usr/bin/env bash

# Включаем прохождение пакетов между сетевыми интерфейсами
sysctl net.ipv4.conf.all.forwarding=1

# Добавим правило iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# service iptables save

# Добавляем маршрут к нашим локальным роутерам
ip route add 192.168.0.0/22 via 192.168.255.2 dev eth1
