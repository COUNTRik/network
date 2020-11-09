# network

Удаляем маршруты по умолчанию и ставим нужные нам маршруты

ip route add 192.168.0.0/28 via 192.168.255.2 dev eth1

Расчитываем сети

## Сеть central

Было:

	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.0/28
	NETMASK=255.255.255.240
	BROADCAST=192.168.0.15
	NETWORK=192.168.0.0
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.32/28
	NETMASK=255.255.255.240
	BROADCAST=192.168.0.47
	NETWORK=192.168.0.32
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.64/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.127
	NETWORK=192.168.0.64

Стало:

	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.0/25
	NETMASK=255.255.255.128
	BROADCAST=192.168.0.127
	NETWORK=192.168.0.0
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.128/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.191
	NETWORK=192.168.0.128
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.0.192/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.255
	NETWORK=192.168.0.192


## Сеть office1

С ней все нормально:

	# ipcalc -b -n -m 192.168.2.0/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.2.63
	NETWORK=192.168.2.0
	# ipcalc -b -n -m 192.168.2.64/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.2.127
	NETWORK=192.168.2.64
	# ipcalc -b -n -m 192.168.2.128/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.2.191
	NETWORK=192.168.2.128
	# ipcalc -b -n -m 192.168.2.192/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.2.255
	NETWORK=192.168.2.192

## Сеть office2

С ней все нормально:

	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.1.0/25 
	NETMASK=255.255.255.128
	BROADCAST=192.168.1.127
	NETWORK=192.168.1.0
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.1.128/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.1.191
	NETWORK=192.168.1.128
	[root@centralRouter vagrant]# ipcalc -n -b -m 192.168.1.192/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.1.255
	NETWORK=192.168.1.192



## Маршруты

Команды inetRouter:
	ip route add 192.168.0.0/24 via 192.168.255.2 dev eth1


Команды centralRouter:

	# ip route del default via 10.0.2.2 dev eth0
	# ip route add default via 192.168.255.1 dev eth1


Команды centralServer:

	[root@centralServer vagrant]# ip route add default via 192.168.0.1 dev eth1
	[root@centralServer vagrant]# ip route del default via 10.0.2.2 dev eth0
