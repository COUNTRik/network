#!/bin/bash

# Включаем прохождение пакетов между сетевыми интерфейсами
sysctl net.ipv4.conf.all.forwarding=1

# Удаляем маргрут по умолчанию и ставим нужные нам маршруты
ip route del default via 10.0.2.2 dev eth0
ip route add default via 192.168.3.1 dev eth1