#!/usr/bin/env bash

# Удаляем маргрут по умолчанию и ставим нужные нам маршруты
ip route del default via 10.0.2.2 dev eth0
ip route add default via 192.168.2.1 dev eth1