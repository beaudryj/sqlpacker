if ($env:install_vbox_tools -eq $true)
{
  Write-Host "Installing Virtualbox Guest Additions"
  certutil -addstore -f "TrustedPublisher" E:\cert\oracle-vbox.cer
  Start-Process -FilePath "E:\VBoxWindowsAdditions.exe" -ArgumentList "/S" -Wait -nonewwindow 
}
else
{
  Write-Host "Skipping installation of Virtualbox Guest Additions"
}
