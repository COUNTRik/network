#!/usr/bin/env bash

# Включаем прохождение пакетов между сетевыми интерфейсами
sysctl net.ipv4.conf.all.forwarding=1

# Удаляем маргрут по умолчанию и ставим нужные нам маршруты
ip route del default via 10.0.2.2 dev eth0
ip route add default via 192.168.255.1 dev eth1
ip route add 192.168.1.0/24 via 192.168.3.3 dev eth2
ip route add 192.168.2.0/24 via 192.168.3.2 dev eth2
