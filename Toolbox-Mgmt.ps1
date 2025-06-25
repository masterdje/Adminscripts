#-----------------Toolbox Management
#-------------------DSIN/SYS/JD-----


function List-Function ($filename)
{
	#Hygiene de code
	
	return cat $filename | Select-String -pattern "function" | sort
}

function Check-Verbs($filename)
{
	#Hygiene de code
	try
	{
		$verbs = @("get","set","compare","list","add","new","prout","remove","find","banner","check")
		$errlist="";$errlist =@()
		foreach ($func in List-Function($filename))
		{
			if (($func | select-string -pattern $verbs) -eq $null) {$errlist += $func}
		}
		return $errlist
	}
	catch [Exception]
	{
		$Error.Exception.Message
	}
}
Function New-SecurePassword()
{
	#Outils
	
	try
	{
		$pwd = Read-Host "Enter a Password"  -maskinput
		$SecurePwd = ConvertTo-SecureString -String $Pwd -AsPlainText -Force
		$EncryptedPwd = ConvertFrom-SecureString -SecureString $SecurePwd
		return $EncryptedPwd #| Out-File -FilePath "\\cred.txt"
	}
	catch [Exception]
	{
		$Error.Exception.Message
	}
}

function Get-OnlineTest()
{
    #Outil
	
	Param
    (
        $Computername
    )

    try
    {
        $connexion = Test-Connection -computername $Computername -Count 1 -ErrorAction stop        
    }
        catch [System.Net.NetworkInformation.PingException]
    {
        return "$Computername offline"
    }
        #Write-Host "$Computername online"
}


function Get-WinRMTest()
{
    Param
    (
        $Computername
    )

	$connexion = Test-WSMan $computername -ea 0
	if (!$connexion) {return "$Computername offline" } else {}
        #Write-Host "$Computername online"
}

function Get-Sha256()
{
	Param
    (
        $file
    )
	
	Return (get-filehash -Algorithm SHA256 $file).hash

}

function Compare-share256 ($file1, $file2)
{
	$sha1=Get-SHA256($file1)
	$sha2=Get-SHA256($file2)
	if ($sha1 -eq $sha2) 
	{
		write-host "Fichiers identiques"
	}
	else
	{
		write-host "Fichiers Differents"
	}
}	

function TimePing ()
{
    Param
    (
        $computername
    )

    try
    {
	while ($true)
        {
		$connexion = Test-Connection -computername $Computername -Count 1 -ErrorAction stop
        write-host "$(get-date)" $connexion.destination $connexion.ipv4Address $connexion.responsetime
		}
		
    }
        catch [System.Net.NetworkInformation.PingException]
    {
        return "$Computername offline"
    }
       
}

function Add-log
{
	param ($strlogfile, $logtext)
	
	try
	{
		[PSCustomObject] $cuLog = ""
		[PSCustomObject] $cuLog =@()
		$callStack = Get-PSCallStack
		#if ($callStack.Count -gt 1) {'Parent function: {0}' -f $callStack[1].FunctionName   }
		$cuLog = [PSCustomObject] @{
			Date = (get-date).tostring()
			Invocation = $callStack[1].FunctionName #$MyInvocation.MyCommand.Name.ToString()
			Log =  $logtext
		}
		$cuLog | Export-Csv -encoding UTF8 -path $strlogfile -append 
	}
	catch [Exception]
	{
	
	Add-content -encoding UTF8 -path "LogErrors.csv" -value((get-date).tostring() + " , " +  $_.Exception.Message)
	
	}
}

function Create-Logfile()
{
	
	try
	{	$callstack = Get-PSCallStack
		$cmdpath = $callstack[-2].command
		$file ="_Log-" + $cmdpath -replace "-Mgmt.ps1",".txt"
		return $file
	}
	catch [Exception]
	{
		$Error.Exception.Message
	}
}

function Get-Context()
{
	try
	{
		$callstack = Get-PSCallStack
		$cmdpath = $callstack[-2].command
		$context= $cmdpath -replace "-Mgmt.ps1",""
		
		[PSCustomObject] $cuCtxt =@()
		$cuCtxt += [PSCustomObject] @{
			Ctxt = $context
			logfile = $logfile #le pb !
		}
	}
	catch [Exception]
	{
		$Error.Exception.Message
		$context="default"
	}
	return $cuctxt
	
}

function Git-Save ($Message)
{   $date= get-date
    $message = "MAJ: " +  $message + " " + $date
	. git add *
	. git commit -m $message
	. git push
}

function Git-Load
{
	. git pull
}

function Git-Check
{
    if (((. git status) | select-string -Pattern ".ps1").count -ne 0){write-host "Git Save nécessaire !"}
}


function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}

function Remove-StringSpecialCharacters
{
   param ([string]$String)

   Begin{}

   Process {

      $String = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))

      $String = $String -replace '-', '' `
                        -replace ' ', '' `
                        -replace '/', '' `
                        -replace '\*', '' `
                        -replace "'", "" 
   }

   End{
      return $String
      }
}
function SleepBar ( $timer , $Description )
{
    #timer = des secondes ... 
    $interval = ($timer*10) 
    for ($i = 1; $i -le 100; $i++ ) {                                                               
        Write-Progress -Activity $Description -Status "$i% Complete:" -PercentComplete $i
        Start-Sleep -Milliseconds $interval
    }
}

function Convert-RGBtoABGR {
     param (
         [Parameter(Mandatory=$true)]
         [ValidateRange(0,255)]
         [int]$R,
         [Parameter(Mandatory=$true)]
         [ValidateRange(0,255)]
         [int]$G,
         [Parameter(Mandatory=$true)]
         [ValidateRange(0,255)]
         [int]$B
     )

     # Convertir chaque composant en hexadécimal sur 2 chiffres
     $hexR = '{0:X2}' -f $R
     $hexG = '{0:X2}' -f $G
     $hexB = '{0:X2}' -f $B

     # Canal alpha toujours FF
     $alpha = 'FF'

     # Format ABGR : Alpha + Blue + Green + Red
     $abgr = "$alpha$hexB$hexG$hexR"
     return $abgr
 }

 function Set-AsAdmin()
{
		if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
}