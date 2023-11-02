#Storyline: Enumerating running services and processes into csv files

#Get processes
Get-Process |Select-Object ProcessName| Export-Csv -Path "C:\users\champuser\Desktop\processes.csv" -NoTypeInformation
#Get services
Get-Service |Select-Object ServiceName| Export-Csv -Path "C:\users\champuser\Desktop\services.csv" -NoTypeInformation