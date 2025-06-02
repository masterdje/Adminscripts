#-----------------SYS Management
#-----------------DSIN/SYS/JD---

. .\Toolbox-Mgmt.ps1
$logFile = "log-m365.txt"

function Sys-banner()
{
	$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 
	
	write-host -foregroundcolor blue "╔░ JD /  AdminScripts ░╗"
	write-host -foregroundcolor blue "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	write-host -foregroundcolor blue "░░      ░░░  ░░░░  ░░░      ░░░  ░░░░  ░░░      ░░░  ░░░░  ░░        ░"
	write-host -foregroundcolor blue "▒  ▒▒▒▒▒▒▒▒▒  ▒▒  ▒▒▒  ▒▒▒▒▒▒▒▒   ▒▒   ▒▒  ▒▒▒▒▒▒▒▒   ▒▒   ▒▒▒▒▒  ▒▒▒▒"
	write-host -foregroundcolor blue "▓▓      ▓▓▓▓▓    ▓▓▓▓▓      ▓▓▓        ▓▓  ▓▓▓   ▓▓        ▓▓▓▓▓  ▓▓▓▓"
	write-host -foregroundcolor blue "███████  █████  ███████████  ██  █  █  ██  ████  ██  █  █  █████  ████"
	write-host -foregroundcolor blue "██      ██████  ██████      ███  ████  ███      ███  ████  █████  ████"
	write-host -foregroundcolor blue "██████████████████████████████████████████████████████████████████████"
	#https://patorjk.com/software/taag/#p=display&f=Shaded%20Blocky&t=MGMT
}                                       

<#
#https://github.com/fleschutz/PowerShell/blob/main/scripts/write-animated.ps1
#https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html?m=1
#https://stackoverflow.com/questions/77821256/how-do-you-load-a-web-page-in-powershell-that-requires-javascript
#>

function Update-All()
{
	try
	{
		. choco upgrade all
		. winget upgrade --all --include-unknown
		. winget settings --enable LocalArchiveMalwareScanOverride
		. winget settings --enable InstallerHadhOverride
		. winget upgrade --all --silent --accept-source-agreements --accept-package-agreements --disable-interactivity --verbose-logs --include-unknown --force --scope machine 
		. winget upgrade --all --silent --accept-source-agreements --accept-package-agreements --disable-interactivity --verbose-logs --include-unknown --force --scope user
	}
	catch
	{
		$Error.Exception.Message
	}
	finally
	{
		$Error.Clear()
	}
}

Function SysMgmt-Update-itNow()
{
	. set-AsAdmin
	. Sys-banner
	. Update-All
}

Function Fresh-Install()
{
	. Set-AsAdmin
	Set-ExecutionPolicy -ExecutionPolicy unrestricted
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

	# Outils
	. winget install -e --id Microsoft.PowerShell
	. winget install -e --id Microsoft.VisualStudioCode
	. winget install -e --id Git.Git
	. winget install -e --id KeePassXCTeam.KeePassXC
	. winget install -e --id Notepad++.Notepad++
	. winget install -e --id GIMP.GIMP
	. winget install -e --id CPUID.HWMonitor
	. winget install -e --id Microsoft.PowerToys
	. winget install -e --id Opera.OperaGX
 
	#Modules PS
	install-module activedirectory -Repository PSGallery -Scope AllUsers -Force -AllowClobber
	install-module Exchangeonline -Repository PSGallery -Scope AllUsers -Force -AllowClobber
	install-module Microsoft.Graph -Repository PSGallery -Scope AllUsers -Force -AllowClobber
	Install-Module -Name Microsoft.Entra -Repository PSGallery -Scope AllUsers -Force -AllowClobber

	. winget upgrade --all
}

