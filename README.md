# network

Удаляем маршруты по умолчанию и ставим нужные нам маршруты

ip route add 192.168.0.0/28 via 192.168.255.2 dev eth1

Расчитываем сети

	$# ipcalc -n -b 192.168.2.0/26
	BROADCAST=192.168.2.63
	NETWORK=192.168.2.0
	$# ipcalc -n -b 192.168.2.64/26
	BROADCAST=192.168.2.127
	NETWORK=192.168.2.64
	$# ipcalc -n -b 192.168.2.128/26
	BROADCAST=192.168.2.191
	NETWORK=192.168.2.128
	$# ipcalc -n -b 192.168.2.192/26
	BROADCAST=192.168.2.255
	NETWORK=192.168.2.192
	$# ipcalc -n -b 192.168.1.0/25
	BROADCAST=192.168.1.127
	NETWORK=192.168.1.0
	$# ipcalc -n -b 192.168.1.128/26
	BROADCAST=192.168.1.191
	NETWORK=192.168.1.128
	$# ipcalc -n -b 192.168.1.192/26
	BROADCAST=192.168.1.255
	NETWORK=192.168.1.192
	$# ipcalc -n -b 192.168.0.0/28
	BROADCAST=192.168.0.15
	NETWORK=192.168.0.0
	$# ipcalc -n -b 192.168.0.32/28
	BROADCAST=192.168.0.47
	NETWORK=192.168.0.32
	$# ipcalc -n -b 192.168.0.64/26
	BROADCAST=192.168.0.127
	NETWORK=192.168.0.64