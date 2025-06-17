#-----------------Web Management
#-----------------DSIN/SYS/JD----

. .\Toolbox-Mgmt.ps1
$logFile = . create-Logfile
$context =  get-Context 


function Web-Banner
{
	write-host $script:logfile
	. Add-log $logfile "Web Banner"
	#https://patorjk.com/software/taag/#p=display&f=Shaded%20Blocky&t=MGMT
	
	$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 
	write-host -foregroundcolor blue "╔░ JD /  AdminScripts ░╗"
	write-host -foregroundcolor blue "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	write-host -foregroundcolor blue "░  ░░░░  ░░        ░░       ░░░  ░░░░  ░░░      ░░░  ░░░░  ░░        ░"
	write-host -foregroundcolor blue "▒  ▒  ▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒   ▒▒   ▒▒  ▒▒▒▒▒▒▒▒   ▒▒   ▒▒▒▒▒  ▒▒▒▒"
	write-host -foregroundcolor blue "▓        ▓▓      ▓▓▓▓       ▓▓▓        ▓▓  ▓▓▓   ▓▓        ▓▓▓▓▓  ▓▓▓▓"
	write-host -foregroundcolor blue "█   ██   ██  ████████  ████  ██  █  █  ██  ████  ██  █  █  █████  ████"
	write-host -foregroundcolor blue "█  ████  ██        ██       ███  ████  ███      ███  ████  █████  ████"
	write-host -foregroundcolor blue "██████████████████████████████████████████████████████████████████████"                               
	$webcxt =  Get-Context
	write-host $webcxt
}


function Web-Server ($path)
{
	. Add-log $logfile "Web Server Launch"
	$httpListener = New-Object System.Net.HttpListener
	$httpListener.Prefixes.Add("http://localhost:9090/")
	$httpListener.Start()
	
	write-host "Appuyer sur une touche pour quitter"
	while (!([console]::KeyAvailable)) {
		$context = $httpListener.GetContext()
		$context.Response.StatusCode = 200
		$context.Response.ContentType = 'text/HTML'
		$WebContent = Get-Content -Path $path -Encoding UTF8
		$EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
		$context.Response.OutputStream.Write($EncodingWebContent , 0, $EncodingWebContent.Length)
		$context.Response.Close()
		Write-Output "" # Newline
	}
	$httpListener.Close()
}

function Web-New-Site($nom)
{
	. Add-log $logfile "New site"
}

function Web-Get-Configuration($file)
{
	. Add-log $logfile "Get Conf"
	$configuration = @{}

	Get-Content $file | ForEach-Object {
		$_ = $_.Trim()
		if (-not ($_ -like "#*" -or $_ -eq "")) 
		{
			$parts = $_ -split "=", 2
			if ($parts.Count -eq 2) 
			{
				$key = $parts[0].Trim()
				$value = $parts[1].Trim().Trim('"')
				$configuration[$key] = $value
			}
		}
	}
	return $configuration
}


function Web-Set-Configuration($file)
{
		. Add-log $logfile "Set Conf"
}


