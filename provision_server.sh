#!/bin/bash
apt-get update
apt-get install -y isc-dhcp-server


#insert the eth2 interface into the DHCP configuration file as the one 
#the server will use to distribute IP addresses
echo 'INTERFACESv4="eth2"' > /etc/default/isc-dhcp-server


#Create a backup copy of the DHCP configuration file
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak


#add network parameters to the DHCP server configuration file
#replaces the content that was there before
cat <<EOT > /etc/dhcp/dhcpd.conf
default-lease-time 86400;
max-lease-time 691200;
option broadcast-address 192.168.57.255;
option routers 192.168.57.10;
option domain-name-servers 8.8.8.8, 4.4.4.4;
option domain-name "micasa.es";


subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.25 192.168.57.50;
  option broadcast-address 192.168.57.255;
  option routers 192.168.57.10;
}

host c2 {
  hardware ethernet 08:00:27:e3:66:90;
  fixed-address 192.168.57.4;
  option domain-name-servers 1.1.1.1;
  default-lease-time 3600;
}
  
EOT


systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
