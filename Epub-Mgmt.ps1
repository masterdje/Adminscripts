function Epub-Banner()
{
	#https://patorjk.com/software/taag/#p=display&f=Shaded%20Blocky&t=MGMT
	$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 
	write-host -foregroundcolor blue "╔░ JD /  AdminScripts ░╗"
	write-host -foregroundcolor blue "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	write-host -foregroundcolor blue "░        ░░       ░░░  ░░░░  ░░       ░░"
	write-host -foregroundcolor blue "▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒"
	write-host -foregroundcolor blue "▓      ▓▓▓▓       ▓▓▓  ▓▓▓▓  ▓▓       ▓▓"
	write-host -foregroundcolor blue "█  ████████  ████████  ████  ██  ████  █"
	write-host -foregroundcolor blue "█        ██  █████████      ███       ██"
	write-host -foregroundcolor blue "████████████████████████████████████████"
 
}

Function Batch-Find-BigFileinEpub($path)
{
	if ($path -eq $null){$path = "F:\livres\calibre\ebooks"}
	write-host $path
	break
	
	[PSCustomObject] $cuObj = ""
	$list = Get-ChildItem -Path $path -Filter "*.epub" -Recurse -File | Where-Object { $_.Length -gt 3MB } | Select-Object FullName, Length
	#foreach ($file in $list) {& ${env:ProgramFiles}\7-Zip\7z.exe d $file.fullname content -y}
	[PSCustomObject] $cuObj =@()
	foreach ($file in $list) 
	{ 
		$zip = Get-7Zip $file.fullname ; 
		$maxfile = ($zip | select index,filename,size | sort size -desc)[0].filename ; 
		$maxsize = ($zip | select index,filename,size | sort size -desc)[0].size ;
		$cuobj += [PSCustomObject] @{
			Path = $file.fullname 
			Maxfile = $maxfile
			Size = $maxsize
			Suspiscious = if (($maxfile.toupper()  -like "*EPUB*") -OR ($maxfile.toupper()  -like "CONTENT") -OR ($maxfile.toupper()  -like "*.EXE*") -OR ($maxfile.toupper()  -like "* MB*")){$true} else {$false}
		}
		write-host "-Traitement de : " $file.fullname
	}
	#write-host $file.fullname ;
	#if ($maxfile.ToUpper() -like "*EPUB")
	#	{write-host $maxfile ; 
	#	& ${env:ProgramFiles}\7-Zip\7z.exe d $file.fullname $maxfile -y  } 
	#else{ write-host $maxfile }  ;
	#& ${env:ProgramFiles}\7-Zip\7z.exe l $file.fullname }
#	$cuobj

	foreach ($element in ($cuobj | where {$_.maxfile.toupper()  -like "*EPUB*"})){ & ${env:ProgramFiles}\7-Zip\7z.exe d $element.path $element.maxfile -y}

}

Function Find-BigFileInEpub($file)
{
	[PSCustomObject] $cuObj = ""
	[PSCustomObject] $cuObj =@()
	$zip = Get-7Zip $file
	$maxfile = ($zip | select index,filename,size | sort size -desc)[0].filename ; 
	$maxsize = ($zip | select index,filename,size | sort size -desc)[0].size ;
	$cuobj += [PSCustomObject] @{
		Path = $file
		Maxfile = $maxfile
		Size = $maxsize
		Suspiscious = if (($maxfile.toupper()  -like "*EPUB*") -OR ($maxfile.toupper()  -like "CONTENT") -OR ($maxfile.toupper()  -like "*.EXE*") -OR ($maxfile.toupper()  -like "* MB*")){$true} else {$false}
	}
	return $cuobj
}

Function Delete-SuspiciousFileInEpub($file)
{
	$list = Find-BigFileInEpub ($file)
	$element=""
	foreach ($element in ($list | where {$_.Suspiscious -eq $true})){ 
		write-host $element.path $element.maxfile
		& ${env:ProgramFiles}\7-Zip\7z.exe d $element.path $element.maxfile -y
	}
}