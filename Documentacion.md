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
