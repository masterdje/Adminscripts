function Web-Server ($path)
{
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