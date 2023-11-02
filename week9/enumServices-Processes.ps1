#Storyline: Enumerating running services and processes into CSV files

#Get Proccesses
Get-Process | Select-Object ProcessName | Export-Csv -Path "C:\Users\champuser\Desktop\processes.csv" -NoTypeInformation

#Get Services
Get-Service | Select-Object ServiceName | Export-Csv -Path "C:\Users\champuser\Desktop\services.csv" -NoTypeInformation