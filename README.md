# network

Дан стенд в виде Vagrantfile, на котором нужно построить следующую архитектуру

Сеть office1

    192.168.2.0/26 - dev
    192.168.2.64/26 - test servers
    192.168.2.128/26 - managers
    192.168.2.192/26 - office hardware

Сеть office2

    192.168.1.0/25 - dev
    192.168.1.128/26 - test servers
    192.168.1.192/26 - office hardware

Сеть central

    192.168.0.0/28 - directors
    192.168.0.32/28 - office hardware
    192.168.0.64/26 - wifi

Office1 ---\
      -----> Central --IRouter --> internet
Office2----/

Проверим и посчитаем сети для их оптимизации.

## Сеть central

В данной сети видим большое количество свободных подсетей

	# ipcalc -n -b -m 192.168.0.0/28
	NETMASK=255.255.255.240
	BROADCAST=192.168.0.15
	NETWORK=192.168.0.0
	# ipcalc -n -b -m 192.168.0.32/28
	NETMASK=255.255.255.240
	BROADCAST=192.168.0.47
	NETWORK=192.168.0.32
	# ipcalc -n -b -m 192.168.0.64/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.127
	NETWORK=192.168.0.64

Изменим разбивку данной сети следующим образом, чтобы не оставить лишних подсетей:

	# ipcalc -n -b -m 192.168.0.0/25
	NETMASK=255.255.255.128
	BROADCAST=192.168.0.127
	NETWORK=192.168.0.0
	# ipcalc -n -b -m 192.168.0.128/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.191
	NETWORK=192.168.0.128
	# ipcalc -n -b -m 192.168.0.192/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.0.255
	NETWORK=192.168.0.192


## Сеть office1

Посчитаем сеть office1:

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

Ошибок в разбивке не найдено.

## Сеть office2

Посчитаем сеть office2:

	# ipcalc -n -b -m 192.168.1.0/25 
	NETMASK=255.255.255.128
	BROADCAST=192.168.1.127
	NETWORK=192.168.1.0
	# ipcalc -n -b -m 192.168.1.128/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.1.191
	NETWORK=192.168.1.128
	# ipcalc -n -b -m 192.168.1.192/26
	NETMASK=255.255.255.192
	BROADCAST=192.168.1.255
	NETWORK=192.168.1.192

Ошибок в разбивке не найдено.

## Предварительная настройка и запуск стенда

Добавим отсутствующие машины в Vagrantfile, также пропишем нужное количество интерфейсов и пропишем в них настройки сетей согласно выше приведенной части.
Итого мы получим следующий список машин

    [inet]
    inetRouter
    
    [local]
    centralRouter
    office1Router
    office2Router
    
    [servers]
    centralServer
    office1Server
    office2Server

Так как в *inetRouter* по заданию стоит Centos 6, некоторые настройки мы произведем с помощью скрипта *scripts/inetRouter.sh* при запуске Vagrantfile.

Подготовим *ansible.cfg* где пропишем путь к inventory и отключим подтверждение ssh ключа.

Запускаем стенд вагрантом
	
	$ vagrant up

В папке *ansible* находятся наши inventory и playbook файлы. 

Проверим модулем *ping* наши машины.

	$ ansible inet -m ping
	inetRouter | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	
	$ ansible local -m ping
	office2Router | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	centralRouter | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	office1Router | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	
	$ ansible servers -m ping
	office2Server | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	office1Server | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}
	centralServer | SUCCESS => {
	    "ansible_facts": {
	        "discovered_interpreter_python": "/usr/bin/python"
	    },
	    "changed": false,
	    "ping": "pong"
	}

Запустим playbook *forwarding.yml*, который во всех роутерах в *sysctl.conf* пропишет *net.ipv4.ip_forward = 1* для включения пересылки пакетов между интерфейсами. Также для тестов он установит утилиту *mtr* на все наши машины.

	$ ansible-playbook ansible/playbook/forwarding.yml 

	PLAY [Install package] ***************************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [centralServer]
	ok: [inetRouter]
	ok: [office1Router]
	ok: [office2Router]
	ok: [centralRouter]
	ok: [office2Server]
	ok: [office1Server]

	TASK [Install user package] **********************************************************
	changed: [centralServer]
	changed: [office2Router]
	changed: [centralRouter]
	changed: [office1Router]
	ok: [inetRouter]
	changed: [office1Server]
	changed: [office2Server]

	PLAY [Enable forwarding ipv4] ********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [centralRouter]
	ok: [office2Router]
	ok: [office1Router]

	TASK [enable forwarding ipv4] ********************************************************
	changed: [office2Router]
	changed: [centralRouter]
	changed: [office1Router]

	TASK [restrat network] ***************************************************************
	changed: [office2Router]
	changed: [office1Router]
	changed: [centralRouter]

	PLAY [Restart network] ***************************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [centralRouter]
	ok: [centralServer]
	ok: [office1Router]
	ok: [office1Server]
	ok: [office2Router]
	ok: [office2Server]

	TASK [restrat network] ***************************************************************
	changed: [office1Server]
	changed: [centralServer]
	changed: [office2Server]
	changed: [office2Router]
	changed: [centralRouter]
	changed: [office1Router]

	PLAY RECAP ***************************************************************************
	centralRouter              : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	centralServer              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	inetRouter                 : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office1Router              : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office1Server              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office2Router              : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office2Server              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Проверим включение пересылки.

	[root@centralRouter vagrant]# cat /proc/sys/net/ipv4/ip_forward
	1

Теперь запустим playbook *route.yml*, который пропишет нужные нам маршруты в наши машины.

	$ ansible-playbook ansible/playbook/route.yml 

	PLAY [Restart network] ***************************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [office1Server]
	ok: [office1Router]
	ok: [centralServer]
	ok: [centralRouter]
	ok: [office2Router]
	ok: [office2Server]

	TASK [restrat network] ***************************************************************
	changed: [office1Server]
	changed: [centralServer]
	changed: [office2Router]
	changed: [centralRouter]
	changed: [office1Router]
	changed: [office2Server]

	PLAY [Route inetRouter] **************************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [inetRouter]

	TASK [add route inetRouter for central, office1, office2 networks] *******************
	changed: [inetRouter]

	PLAY [Route centralRouter] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [centralRouter]

	TASK [del default route] *************************************************************
	changed: [centralRouter]

	TASK [add default inetRouter] ********************************************************
	changed: [centralRouter]

	TASK [add office2 route] *************************************************************
	changed: [centralRouter]

	TASK [add office1 route] *************************************************************
	changed: [centralRouter]

	PLAY [Route office1Router] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [office1Router]

	TASK [del default route] *************************************************************
	changed: [office1Router]

	TASK [add default route centralRoute] ************************************************
	changed: [office1Router]

	PLAY [Route office2Router] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [office2Router]

	TASK [del default route] *************************************************************
	changed: [office2Router]

	TASK [add default route centralRoute] ************************************************
	changed: [office2Router]

	PLAY [Route centralServer] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [centralServer]

	TASK [del default route] *************************************************************
	changed: [centralServer]

	TASK [add default route centralRoute] ************************************************
	changed: [centralServer]

	PLAY [Route office1Server] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [office1Server]

	TASK [del default route] *************************************************************
	changed: [office1Server]

	TASK [add default route office1Router] ***********************************************
	changed: [office1Server]

	PLAY [Route office2Server] ***********************************************************

	TASK [Gathering Facts] ***************************************************************
	ok: [office2Server]

	TASK [del default route] *************************************************************
	changed: [office2Server]

	TASK [add default route office2Router] ***********************************************
	changed: [office2Server]

	PLAY RECAP ***************************************************************************
	centralRouter              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	centralServer              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	inetRouter                 : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office1Router              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office1Server              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office2Router              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	office2Server              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Примечание: маршруты прописываются командой *ip route*, после перезагрузки машин эти маршруты сбросятся к маршрутам по умолчанию. Для восстановления маршрутов после перезагрузки, можно использовать еще раз playbook *route.yml* с указанием нужной нам машины.

Проверим соединение с Интернетом.

	[vagrant@centralServer ~]$ ping 8.8.8.8
	PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
	64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=37.6 ms
	64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=37.3 ms
	64 bytes from 8.8.8.8: icmp_seq=3 ttl=59 time=37.4 ms
	64 bytes from 8.8.8.8: icmp_seq=4 ttl=59 time=37.4 ms

Проверим соединение *centralServer* с другими серверами

*office1Server*

	[vagrant@centralServer ~]$ tracepath -n 192.168.2.4
	 1?: [LOCALHOST]                                         pmtu 1500
	 1:  192.168.0.1                                           0.700ms 
	 1:  192.168.0.1                                           0.462ms 
	 2:  192.168.3.2                                           1.108ms 
	 3:  192.168.2.4                                           1.411ms reached
	     Resume: pmtu 1500 hops 3 back 3

*office2Server*

	[vagrant@centralServer ~]$ tracepath -n 192.168.1.4
	 1?: [LOCALHOST]                                         pmtu 1500
	 1:  192.168.0.1                                           0.581ms 
	 1:  192.168.0.1                                           0.549ms 
	 2:  192.168.3.3                                           1.084ms 
	 3:  192.168.1.4                                           1.456ms reached
	     Resume: pmtu 1500 hops 3 back 3