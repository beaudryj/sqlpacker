function Invoke-InstallSQL{
$output = "C:\SqlDownload\SQLEXPR_x64_ENU.exe"
$time = Get-Date
write-output "Extracting SQL Download - $Time" 

start-process $output "/q /x:C:\SQL\SqlExpr" -wait -nonewwindow

$time = Get-Date
write-output "Finished Extracting SQL Download- $Time" 

$SQL =  "C:\SQL\SqlExpr\SETUP.EXE"


$time = Get-Date
write-output "Installing SQL - $Time" 

$InstallFlags = '/ACTION=PrepareImage /FEATURES=SQLEngine /InstanceID="SQLExpress" /IACCEPTSQLSERVERLICENSETERMS /Q'
Start-Process $SQL -ArgumentList $InstallFlags -wait -nonewwindow


$time = Get-Date
write-output "Finished Installing SQL - $Time" 

}





function Invoke-DownloadSQL($url, $targetFile)
{
   $uri = New-Object "System.Uri" "$url"
   $request = [System.Net.HttpWebRequest]::Create($uri)
   $request.set_Timeout(15000) #15 second timeout
   $response = $request.GetResponse()
   $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
   $responseStream = $response.GetResponseStream()
   $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
   $buffer = new-object byte[] 10KB
   $count = $responseStream.Read($buffer,0,$buffer.length)
   $downloadedBytes = $count
   while ($count -gt 0)
   {
       $targetStream.Write($buffer, 0, $count)
       $count = $responseStream.Read($buffer,0,$buffer.length)
       $downloadedBytes = $downloadedBytes + $count
       Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
   }
   Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"
   $targetStream.Flush()
   $targetStream.Close()
   $targetStream.Dispose()
   $responseStream.Dispose()
}


New-Item C:\SqlDownload -ItemType Directory -Force

Add-WindowsFeature NET-Framework-Core
Invoke-DownloadSQL -url "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe" -targetFile "C:\SqlDownload\SQLEXPR_x64_ENU.exe"
Invoke-InstallSQL
