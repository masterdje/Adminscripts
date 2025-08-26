#-----------------Docker Management
#-----------------DSIN/SYS/JD----

. .\Toolbox-Mgmt.ps1
$logFile = . create-Logfile
$context =  get-Context 


function Docker-Banner()
{
	write-host $script:logfile
	. Add-log $logfile "Docker Banner"
	#https://patorjk.com/software/taag/#p=display&f=Shaded%20Blocky&t=DOCKER
	$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 
	write-host -foregroundcolor blue "╔░ JD /  AdminScripts ░╗"
	write-host -foregroundcolor blue "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	write-host -foregroundcolor blue "░       ░░░░      ░░░░      ░░░  ░░░░  ░░        ░░       ░░"
	write-host -foregroundcolor blue "▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒  ▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒"
	write-host -foregroundcolor blue "▓  ▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓▓▓▓▓     ▓▓▓▓▓      ▓▓▓▓       ▓▓"
	write-host -foregroundcolor blue "█  ████  ██  ████  ██  ████  ██  ███  ███  ████████  ███  ██"
	write-host -foregroundcolor blue "█       ████      ████      ███  ████  ██        ██  ████  █"
	write-host -foregroundcolor blue "████████████████████████████████████████████████████████████"
		
	$epubcxt =  Get-Context
	write-host $epubcxt
}



function Docker-Install
{
# Docker Installation Script for Windows 11
# Run this script in PowerShell as Administrator

Write-Host "Activating required Windows features: Hyper-V and Containers..."
Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All -NoRestart

Write-Host "Installing DockerMsftProvider module..."
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Write-Host "Installing Docker package..."
Install-Package -Name docker -ProviderName DockerMsftProvider -Force

Write-Host "Restarting the computer to complete installation..."
Restart-Computer -Force

# After reboot, verify Docker installation
# docker version

}