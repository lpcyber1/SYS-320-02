#Storyline: Script to parse threat intel from emergingthreats.com and create firewall rules

﻿#Array of websites with threat intel
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

#Loop through the URLs for the rules list
foreach ($u in $drop_urls) {
    #Correctly extract the file name
    $temp = $u.split("/")
    $file_name = $temp[-1]

    if (Test-Path $file_name) {
        
        continue

     } else {
        #Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name
    }
}

#Array containing the file name
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')

#Extract the IP addresses
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

#Append the IP addresses to the temporary IP list
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

#Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
#After the IP addresses, add the remaining IPTables syntax and save the results to a file.
(Get-Content -Path ".\ips-bad.tmp") | % `
{ $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP" } | `
Out-File -FilePath "iptables.bash"

# Use a switch statement to create an IPTables and Windows firewall ruleset based on user choice
$choice = Read-Host "Do you want to create an IPTables or Windows firewall ruleset? (IPTABLES/WINDOWS)"
switch ($choice) {
    'IPTABLES' {
        # Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
        # After the IP address, add the remaining IPTables syntax and save the results to a file.
        (Get-Content -Path ".\ips-bad.tmp") | % `
        { $_ -replace '^', 'iptables -A INPUT -s ' -replace '$', ' -j DROP' } | `
        Out-File -FilePath ".\iptables.bash"
    }

    'WINDOWS' {
        #Do the same for the Windows firewall syntax
        (Get-Content -Path ".\ips-bad.tmp") | % `
        { $_ -replace '^', 'netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - ' -replace '$', '"' } | `
        Out-File -FilePath ".\winfw.netsh"
    }

} #close switch statement