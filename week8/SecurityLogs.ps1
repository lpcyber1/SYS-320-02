#Storyline: Review the security Event log

#User input

#Directory to save files:
$myDir = "C:\Users\champuser\Desktop\"

#List all the available windows event logs
Get-EventLog -List

#Create a prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"
$searchPhrase = Read-host -Prompt "Please enter the value you want to search for"
#Print the results for the log
Get-EventLog -LogName $readLog | where {$_.Message -ilike "$searchPhrase" } | Export-Csv -NoTypeInformation -Path "$myDir\securityLogs.csv"