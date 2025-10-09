## 1
We will create a DHCP server (server) and two clients (c1 and c2) that will obtain their
configuration from the server automatically (c2 based on its MAC address).

---

## 2
In this section, we configure the machines with their corresponding network adapters and IP addresses. This is configured in the vagrantfile, the file that is created at the beginning of the exercise and which allows us to assign IP addresses to the machines as well as the box and many other things. 
Next, we will install the DHCP service with the command we have configured in our provision_server.sh file (apt-get install -y isc-dhcp-server). We will also create a copy of the dhcp configuration file in case we need to refer to it. We do this with the command “cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak”.
---

## 3
In this section, we have configured all machines to be within the same network (192.168.57.0/24).
We have also configured the ranges of IP addresses that the server will dynamically distribute, which are 192.168.57.25 to 192.168.57.50. We have also configured the default lease time, the broadcast address, the gateway, the DNS servers, and the domain name. 
We did this by modifying the file “/etc/dhcp/dhcpd.conf”. 
This was the result of the command “sudo nano /etc/dhcp/dhcpd.conf”:

default-lease-time 86400;
max-lease-time 691200;
option broadcast-address 192.168.57.255;
option routers 192.168.57.10;
option domain-name-servers 8.8.8.8, 4.4.4.4;
option domain-name "micasa.es";

subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.25 192.168.57.50;
}

In the verification section, we check that the service is correct. 
vagrant@server:~$ sudo systemctl restart isc-dhcp-server
vagrant@server:~$ sudo dhcpd -t
Internet Systems Consortium DHCP Server 4.4.3-P1
Copyright 2004-2022 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/
Config file: /etc/dhcp/dhcpd.conf
Database file: /var/lib/dhcp/dhcpd.leases
PID file: /var/run/dhcpd.pid
vagrant@server:~$ sudo dhcpd -d
Internet Systems Consortium DHCP Server 4.4.3-P1
Copyright 2004-2022 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/
Config file: /etc/dhcp/dhcpd.conf
Database file: /var/lib/dhcp/dhcpd.leases
PID file: /var/run/dhcpd.pid
There's already a DHCP server running.

If you think you have received this message due to a bug rather
than a configuration issue please read the section on submitting
bugs on either our web page at www.isc.org or in the README file
before submitting a bug.  These pages explain the proper
process and the information we find helpful for debugging.

exiting.

---

## 4
In this section, we are going to configure the c1 machine, which we only need to start up with “vagrant up c1” since all of its configuration is in our vagrant file.

## 4.1
Now we can see the results of comands:
ip a (before running ifup,ifdown and requesting an IP address with dhclient)

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:6b:55:2b brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86204sec preferred_lft 86204sec
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:8d:74:3d brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    inet 192.168.57.25/24 brd 192.168.57.255 scope global dynamic eth1
       valid_lft 86210sec preferred_lft 86210sec

ip a (after running ifup,ifdown and requesting an IP address with dhclient)

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:6b:55:2b brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85780sec preferred_lft 85780sec
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:8d:74:3d brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    inet 192.168.57.25/24 brd 192.168.57.255 scope global dynamic eth1
       valid_lft 85786sec preferred_lft 85786sec
    inet 192.168.57.27/24 brd 192.168.57.255 scope global secondary dynamic eth1
       valid_lft 86392sec preferred_lft 86392sec

result of the dhclient -v command that gives us the new IP address

vagrant@c1:~$ sudo dhclient -v
Internet Systems Consortium DHCP Client 4.4.3-P1
Copyright 2004-2022 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/eth1/08:00:27:8d:74:3d
Sending on   LPF/eth1/08:00:27:8d:74:3d
Listening on LPF/eth0/08:00:27:6b:55:2b
Sending on   LPF/eth0/08:00:27:6b:55:2b
Sending on   Socket/fallback
DHCPREQUEST for 192.168.57.27 on eth1 to 255.255.255.255 port 67
DHCPREQUEST for 10.0.2.15 on eth0 to 255.255.255.255 port 67
DHCPACK of 192.168.57.27 from 192.168.57.10
RTNETLINK answers: File exists
bound to 192.168.57.27 -- renewal in 34653 seconds.

---

## 4.2
Since Debian 12 is more modern, the syslog file becomes the command “sudo journalctl -u isc-dhcp-server.” 
This is the result:

vagrant@server:~$ sudo journalctl -u isc-dhcp-server | grep DHCP
Oct 09 13:45:26 server systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
Oct 09 13:45:28 server isc-dhcp-server[2770]: Starting ISC DHCPv4 server: dhcpdcheck syslog for diagnostics. ... failed!
Oct 09 13:45:28 server systemd[1]: Failed to start isc-dhcp-server.service - LSB: DHCP server.
Oct 09 13:45:31 server systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
Oct 09 13:45:33 server isc-dhcp-server[2796]: Starting ISC DHCPv4 server: dhcpd.
Oct 09 13:45:33 server systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.
Oct 09 13:47:05 server dhcpd[2808]: DHCPDISCOVER from 08:00:27:8d:74:3d via eth2
Oct 09 13:47:06 server dhcpd[2808]: DHCPOFFER on 192.168.57.25 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 13:47:06 server dhcpd[2808]: DHCPREQUEST for 192.168.57.25 (192.168.57.10) from 08:00:27:8d:74:3d (c1) via eth2
Oct 09 13:47:06 server dhcpd[2808]: DHCPACK on 192.168.57.25 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 13:48:29 server dhcpd[2808]: DHCPDISCOVER from 08:00:27:e3:66:90 via eth2
Oct 09 13:48:30 server dhcpd[2808]: DHCPOFFER on 192.168.57.26 to 08:00:27:e3:66:90 (c2) via eth2
Oct 09 13:48:30 server dhcpd[2808]: DHCPREQUEST for 192.168.57.26 (192.168.57.10) from 08:00:27:e3:66:90 (c2) via eth2
Oct 09 13:48:30 server dhcpd[2808]: DHCPACK on 192.168.57.26 to 08:00:27:e3:66:90 (c2) via eth2
Oct 09 13:57:11 server dhcpd[2808]: DHCPDISCOVER from 08:00:27:8d:74:3d via eth2
Oct 09 13:57:12 server dhcpd[2808]: DHCPOFFER on 192.168.57.27 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 13:57:12 server dhcpd[2808]: DHCPREQUEST for 192.168.57.27 (192.168.57.10) from 08:00:27:8d:74:3d (c1) via eth2
Oct 09 13:57:12 server dhcpd[2808]: DHCPACK on 192.168.57.27 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:06:56 server dhcpd[2808]: DHCPREQUEST for 192.168.57.27 from 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:06:56 server dhcpd[2808]: DHCPACK on 192.168.57.27 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:07:02 server dhcpd[2808]: DHCPREQUEST for 192.168.57.27 from 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:07:02 server dhcpd[2808]: DHCPACK on 192.168.57.27 to 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:07:37 server dhcpd[2808]: DHCPREQUEST for 192.168.57.27 from 08:00:27:8d:74:3d (c1) via eth2
Oct 09 14:07:37 server dhcpd[2808]: DHCPACK on 192.168.57.27 to 08:00:27:8d:74:3d (c1) via eth2

---

## 4.3
The /var/lib/dhcp/dhcpd.leases file shows the IP addresses assigned by the DHCP server to clients.
Each lease block contains information such as the assigned IP address, the start and end times, the host name, etc.
Results of command that view this file:

vagrant@server:~$ sudo cat /var/lib/dhcp/dhcpd.leases
The format of this file is documented in the dhcpd.leases(5) manual page.
This lease file was written by isc-dhcp-4.4.3-P1

authoring-byte-order entry is generated, DO NOT DELETE
authoring-byte-order little-endian;

server-duid "\000\001\000\0010zx\373\010\000'!}*";

lease 192.168.57.25 {
  starts 4 2025/10/09 13:47:06;
  ends 5 2025/10/10 13:47:06;
  cltt 4 2025/10/09 13:47:06;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 08:00:27:8d:74:3d;
  uid "\377'\215t=\000\001\000\0010zyY\010\000'\215t=";
  client-hostname "c1";
}
lease 192.168.57.26 {
  starts 4 2025/10/09 13:48:30;
  ends 5 2025/10/10 13:48:30;
  cltt 4 2025/10/09 13:48:30;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 08:00:27:e3:66:90;
  uid "\377'\343f\220\000\001\000\0010zy\256\010\000'\343f\220";
  client-hostname "c2";
}
lease 192.168.57.27 {
  starts 4 2025/10/09 13:57:12;
  ends 5 2025/10/10 13:57:12;
  cltt 4 2025/10/09 13:57:12;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 08:00:27:8d:74:3d;
  client-hostname "c1";
}

---

## 5
For this section, we have taken the MAC address “08:00:27:e3:66:90,” which gave us the command "ip a".
We have modified the “dhcpd.conf” file.We have included the MAC address, lease time requirements, and DNS.
This is the result of the command “sudo nano /etc/dhcp/dhcpd.conf”:

default-lease-time 86400;
max-lease-time 691200;
option broadcast-address 192.168.57.255;
option routers 192.168.57.10;
option domain-name-servers 8.8.8.8, 4.4.4.4;
option domain-name "micasa.es";

subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.25 192.168.57.50;
}
host c2 {
  hardware ethernet 08:00:27:e3:66:90;
  fixed-address 192.168.57.4;
  option domain-name-servers 1.1.1.1;
  default-lease-time 3600;
}

We have reset the service and in the status command output we can see how it is running.
vagrant@server:~$ sudo systemctl restart isc-dhcp-server
vagrant@server:~$ sudo systemctl status isc-dhcp-server
● isc-dhcp-server.service - LSB: DHCP server
     Loaded: loaded (/etc/init.d/isc-dhcp-server; generated)
     Active: active (running) since Thu 2025-10-09 15:58:35 UTC; 8s ago
       Docs: man:systemd-sysv-generator(8)
    Process: 3232 ExecStart=/etc/init.d/isc-dhcp-server start (code=exited, status=0/SUCCESS)
      Tasks: 1 (limit: 2307)
     Memory: 4.1M
        CPU: 60ms
     CGroup: /system.slice/isc-dhcp-server.service
             └─3245 /usr/sbin/dhcpd -4 -q -cf /etc/dhcp/dhcpd.conf eth2

Oct 09 15:58:32 server systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
Oct 09 15:58:33 server isc-dhcp-server[3232]: Launching IPv4 server only.
Oct 09 15:58:33 server dhcpd[3245]: Wrote 0 deleted host decls to leases file.
Oct 09 15:58:33 server dhcpd[3245]: Wrote 0 new dynamic host decls to leases file.
Oct 09 15:58:33 server dhcpd[3245]: Wrote 3 leases to leases file.
Oct 09 15:58:33 server dhcpd[3245]: Server starting service.
Oct 09 15:58:35 server isc-dhcp-server[3232]: Starting ISC DHCPv4 server: dhcpd.
Oct 09 15:58:35 server systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.

We have requested a new IP address with dhclient, and when we run the ip a command, we can see that 
the IP address “192.168.57.4/24” has been correctly assigned. 
vagrant@c2:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:6b:55:2b brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 78527sec preferred_lft 78527sec
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:e3:66:90 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    inet 192.168.57.26/24 brd 192.168.57.255 scope global dynamic eth1
       valid_lft 78530sec preferred_lft 78530sec
    inet 192.168.57.4/24 brd 192.168.57.255 scope global secondary dynamic eth1
       valid_lft 3595sec preferred_lft 3595sec

Finally, we check the DNS in the file “/etc/resolv.conf.”
vagrant@c2:~$ cat /etc/resolv.conf
nameserver 1.1.1.1
nameserver 4.2.2.1
nameserver 208.67.220.220
search home micasa.es