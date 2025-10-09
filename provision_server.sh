#!/bin/bash
apt-get update
apt-get install -y isc-dhcp-server


echo 'INTERFACESv4="eth2"' > /etc/default/isc-dhcp-server

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

cat <<EOT > /etc/dhcp/dhcpd.conf
default-lease-time 86400;
max-lease-time 691200;
option broadcast-address 192.168.57.255;
option routers 192.168.57.10;
option domain-name-servers 8.8.8.8, 4.4.4.4;
option domain-name "micasa.es";

subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.25 192.168.57.50;
}
EOT

systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
