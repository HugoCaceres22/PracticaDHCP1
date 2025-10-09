#!/bin/bash
# Update and install DHCP
apt-get update
apt-get install -y isc-dhcp-server

# Set interface for DHCP (second interface)
echo 'INTERFACESv4="eth2"' > /etc/default/isc-dhcp-server

# Backup original config
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

# DHCP configuration
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

# Restart and enable DHCP
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
