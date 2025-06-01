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

function Set-AsAdmin()
{
		if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
}


Function SysMgmt-Do-itNow()
{
	. set-AsAdmin
	. Sys-banner
	. Update-All
}

. SysMgmt-Do-itNow