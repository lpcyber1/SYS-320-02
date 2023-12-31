#Storyline: Script to start and stop windows calculator

#Starts the calculator
$calculator = Start-Process "calc.exe" -PassThru

#Stops the calculator
Read-Host -Prompt "To stop the calculator press enter"

$CheckCalculator = Get-Process | Where-Object { $_.MainWindowTitle -like "*calc*" }
if ($CheckCalculator) {
	Stop-Process -Id $CheckCalculator.Id -Force
	Write-Host "calculator has been stopped"
	
} else {
	Write-Host "Calculator is not running"
}