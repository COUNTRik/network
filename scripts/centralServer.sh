# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Устанавливаем необходимые пакеты
yum install -y mtr vim

# Удаляем маршрут по умолчанию от вагранта
ip route del default via 10.0.2.2 dev eth0

# Добавляем маршрут по умолчанию через central
ip route add default via 192.168.0.1 dev eth1