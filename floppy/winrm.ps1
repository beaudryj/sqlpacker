##############
# Enable WinRM
##############

New-Item                                                                       `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" `
    -Force

Set-NetConnectionProfile                                                       `
    -InterfaceIndex (Get-NetConnectionProfile).InterfaceIndex                  `
    -NetworkCategory Private

Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value True
Set-Item WSMan:\localhost\Service\Auth\Basic       -Value True

netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow