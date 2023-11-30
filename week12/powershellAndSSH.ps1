#Storyline: Login to a remote SSH server

#Starting the SSH session
Import-Module Posh-SSH
New-SSHSession -ComputerName '184.171.149.26' (Get-credential liam)

#Uploading the file to my Ubuntu VM through the SSH session 
Set-SCPItem -ComputerName '184.171.149.26' -Credential (Get-credential liam) -Path '.\powershellandSSHfile.txt' -Destination '/home/liam' -Verbose