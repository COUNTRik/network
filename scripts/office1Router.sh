# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Устанавливаем необходимые пакеты
yum install -y mtr vim

# Включаем прохождение пакетов между сетевыми интерфейсами
sysctl net.ipv4.conf.all.forwarding=1

# Удаляем маршрут по умолчанию от вагранта
ip route del default via 10.0.2.2 dev eth0

# Добавляем маршрут по умолчанию через inetRouter
ip route add default via 192.168.255.1 dev eth1