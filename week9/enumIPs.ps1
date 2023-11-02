#Storyline: Enumerating IPs of DHCP, DNS, Default Gateway

#Enumerates IPs
Get-WmiObject Win32_NetworkAdapterConfiguration | Select DHCPServer, DNSServerSearchOrder, IPAddress, DefaultIPGateway | Where  { $_.IPAddress, $_.DHCPServer, $_.DNSServerSearchOrder, $_.DefaultIPGateway }