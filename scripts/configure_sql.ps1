$InstallSQL = @"
New-Item -Path 'C:\MSSQLSERVER' -Force -ItemType Directory
New-Item -Path 'C:\MSSQLSERVER\Databases' -Force -ItemType Directory
New-Item -Path 'C:\MSSQLSERVER\Backup' -Force -ItemType Directory
New-Item -Path 'C:\MSSQLSERVER\Logs' -Force -ItemType Directory
New-Item -Path 'C:\MSSQLSERVER\TempDB' -Force -ItemType Directory

`$sqlSettings = @(
    "/ACTION=""CompleteImage"""
    "/Q"
    "/INSTANCEID=""SQLExpress"""
    "/INSTANCENAME=""SQLExpress"""
    "/AGTSVCACCOUNT=""vagrant"""
    "/AGTSVCPASSWORD=""vagrant"""
    '/AGTSVCSTARTUPTYPE="Automatic"'
    '/SQLSVCSTARTUPTYPE="Automatic"'
    '/SQLCOLLATION="Latin1_General_CI_AS"'
    "/SQLSVCACCOUNT=""vagrant"""
    "/SQLSVCPASSWORD=""vagrant"""
    "/ASSYSADMINACCOUNTS=""Administrators"""
    '/SQLBACKUPDIR="C:\MSSQLSERVER\Backup"'
    '/SECURITYMODE="SQL"'
    '/SAPWD="0nlineApp!"'
    '/SQLUSERDBDIR="C:\MSSQLSERVER\Databases"'
    '/SQLUSERDBLOGDIR="C:\MSSQLSERVER\Logs"'
    '/SQLTEMPDBDIR="C:\MSSQLSERVER\TempDB"'
    '/ADDCURRENTUSERASSQLADMIN="False"'
    '/SQLSYSADMINACCOUNTS="vagrant" "administrator"'
    '/TCPENABLED="1"'
    '/BROWSERSVCSTARTUPTYPE="Automatic"'
    '/IAcceptSQLServerLicenseTerms'
)

`$sqlSettingsString = `$sqlSettings -join " "


Start-Process -FilePath "C:\SQL\SqlExpr\SETUP.EXE" -ArgumentList `$sqlSettingsString -Wait -NoNewWindow

"@



New-Item C:\SQL\Invoke-ConfigureSQL.ps1 -type file -force -value $InstallSQL


$secpasswd = ConvertTo-SecureString vagrant -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("Administrator", $secpasswd)

Register-ScheduledJob -Name "InstallSQL" -FilePath "C:\SQL\Invoke-ConfigureSql.ps1" -Credential $credential -MaxResultcount 30 -ScheduledJobOption (New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery) -Trigger (New-JobTrigger -AtStartup)



