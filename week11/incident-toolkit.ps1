#Storyline: Script to get; running processes and path, registered services and path, TCP network socket, user acct info, network adapter config info, and 4 other userful artifcats

#Function to get running processes
function Get-RunningProcesses {
    Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$outputPath\processes.csv" -NoTypeInformation
}

#Function to get all registered services
function Get-Services {
    Get-WmiObject Win32_Service | Select-Object DisplayName, PathName | Export-Csv -Path "$outputPath\services.csv" -NoTypeInformation
}

#Function to get all TCP network sockets
function Get-TcpSockets {
    Get-NetTCPConnection | Export-Csv -Path "$outputPath\tcpSockets.csv" -NoTypeInformation
}

#Function to get all user account information
function Get-UserAccounts {
    Get-WmiObject Win32_UserAccount | Select-Object Name, FullName, Domain | Export-Csv -Path "$outputPath\userAccounts.csv" -NoTypeInformation
}

#Function to get all Network Adapter Configuration information
function Get-NetworkAdapterConfig {
    Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object Description, IPAddress, DefaultIPGateway | Export-Csv -Path "$outputPath\networkAdapterConfiguration.csv" -NoTypeInformation
}

#Prompt user for output location
$outputPath = Read-Host "Enter the output directory path"

#Checks if the output directory exists
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath | Out-Null
}

#Executing the functions
Get-RunningProcesses
Get-Services
Get-TcpSockets
Get-UserAccounts
Get-NetworkAdapterConfig

#Additional PowerShell cmdlets

#Checks the System event log for changes made in the past 7 days
Get-EventLog -LogName System -After (Get-Date).AddDays(-7) | Export-Csv -Path "$outputPath\systemEvents.csv" -NoTypeInformation
#Checks the Security log for changes made in the past 7 days
Get-EventLog -LogName Security -After (Get-Date).AddDays(-7) | Export-Csv -Path "$outputPath\securityEvents.csv" -NoTypeInformation
#Checks the Application log for applications from the past 7 days
Get-EventLog -LogName Application -After (Get-Date).AddDays(-7) | Export-Csv -Path "$outputPath\applicationEvents.csv" -NoTypeInformation
#Gets each running process and calculates the hash of it
Get-Process | Get-FileHash | Format-Table Hash, Path | Export-Csv -Path "$outputPath\fileHashes.csv" -NoTypeInformation

#I chose to use Get-EventLog for the System, Security, and Application event logs because these logs contatin all of the information regarding system events, security incidents, and application errors. So retrieving information from these from the past 7 days is very useful and can help identify issues.
#The Get-Process and Get-FileHash were chosen because they can give information on running processes and calculate a hash for any process execcutable. It helps detect anything suspicious or unauthorized processes on the system and creates a record of the executable file hashes for forensic analysis.


#Create checksum file for CSV files
Get-ChildItem -Path $outputPath -Filter *.csv | ForEach-Object {
    $hash = Get-FileHash -Path $_.FullName
    "$($hash.Hash)  $($_.Name)" | Out-File -Append "$outputPath\checksums.txt"
}

#Zip the results directory
Compress-Archive -Path $outputPath -DestinationPath "$outputPath\results.zip"

#Create checksum for the zip file
$zipHash = Get-FileHash -Path "$outputPath\results.zip"
"$($zipHash.Hash)  results.zip" | Out-File -Append "$outputPath\checksums.txt"

#Shows the user the script is finished and where the results have been saved
Write-Host "Script execution completed. Results saved in: $outputPath"