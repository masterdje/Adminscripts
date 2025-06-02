#-----------------GO Dev !----
#-----------------DSIN/SYS/JD-


#init
$devpath= "" 
$logpath = "" 
Set-Alias -Name "ST" -Value "stop-transcript"

#StartUp
cls

#Gameplay-loop

if($args -eq "M365")
{
	$devpath= "dev\scripts\m365-repo"
	$logpath = (get-date).ticks ; $logpath = "logs\" + [string]$logpath + ".txt"
	cd\
	cd $devpath
	. .\M365-Mgmt.ps1
	. M365-banner
}

if($args -eq "AdminScripts")
{
	$devpath= "dev\scripts\AdminiScripts"
	$logpath = (get-date).ticks ; $logpath = "logs\" + [string]$logpath + ".txt"
	cd\
	cd $devpath
	. .\Sys-Mgmt.ps1
	. Sys-banner
}

	start-transcript -path $logpath > $null
	write-host "<Transcript ON>  <ST pour stop> <cat $logpath pour analyse>"
