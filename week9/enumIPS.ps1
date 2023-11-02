#Storyline: Enumerating DHCP and DNS server IPs

#Getting DHCP, DNS, DHCP, IP Address
Get-WmiObject Win32_NetworkAdapterConfiguration | Select DHCPServer, DNSServerSearchOrder, IPAddress, DefaultIPGateway |  Where { $_.DHCPServer, $_.DNSServerSearchOrder, $_.IPAddress, $_.DefaultIPGateway }
