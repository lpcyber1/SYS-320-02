#Storyline: A program that lists all registered servers (stopped or runnining)

#Array for options
$options = @('all', 'stopped', 'running', 'quit')

function showService($selectOption) {
	#Checks entered value
	if ($selectOption -eq 'all') {
	Get-Service | Format-Table -AutoSize
	} elseif ($selectOption -eq 'stopped') {
		Get-Service | Where-Object {$_.Status -eq 'Stopped'} | Format-Table -AutoSize
	} elseif ($selectOption -eq 'running') {
		Get-Service | Where-Object {$_.Status -eq 'Running'} | Format-Table -AutoSize
	} 
} #end

#Loops the program
while ($true) {
	Write-Host "Choose an option:"
	Write-Host "  1. All Services"
	Write-Host "  2. Stopped services"
	Write-Host "  3. Running services"
	Write-Host "  4. Quit"
	
	#Asks user for option
	$OptionSelect = Read-Host "Please enter an option (1/2/3/4)"
	
	#If option 4 is entered
	if ($OptionSelect -eq '4') {
		cls
		break
	}
	#Checks if the option selected is valid
	if ($OptionSelect -in '1', '2', '3') {
		showService $options[$OptionSelect - 1]
	} else {
		Write-Host "Invalid choice. Please select a valid option."
		Read-Host "Press Enter to continue."
	}
}
		
	