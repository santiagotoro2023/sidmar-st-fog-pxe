#PF Script zum installieren von Nuget, PSWindowsUpdate und Windows Updates.
try {
    Write-Host -ForegroundColor Yellow "Installing Nuget Provider Module..."
    Install-PackageProvider -Name Nuget -Force -ForceBootstrap
    Write-Host -ForegroundColor Green "Successfully installed NuGet provider."
} catch {
    Write-Host -ForegroundColor Red "Failed to install or verify NuGet provider: $_"
    pause
    exit
}
#Set-ExecutionPolicy RemoteSigned -Force -- Auskommentiert weil in init.cmd schon ExecutionPolicy auf Bypass gesetzt wird.
try {
    Write-Host -ForegroundColor Yellow "Installing PSWindowsUpdate Module..."
    Install-Module PSWindowsUpdate -Force
    Write-Host -ForegroundColor Green "Successfully installed PSWindowsUpdate Module."
} catch {
    Write-Host -ForegroundColor Red "Failed to install or verify PSWindowsUpdate Module: $_"
    pause
    exit
}
try {
    Write-Host -ForegroundColor Yellow "Importing PSWindowsUpdate Module..."
    Import-Module PSWindowsUpdate
    Write-Host -ForegroundColor Green "Successfully imported PSWindowsUpdate Module."
} catch {
    Write-Host -ForegroundColor Red "Failed to install or verify import of PSWindowsUpdate Module: $_"
    pause
    exit
}
#Set-ExecutionPolicy Restricted -Force -- Auskommentiert weil in init.cmd schon ExecutionPolicy auf Bypass gesetzt wird.
try {
    Write-Host -ForegroundColor Yellow "Retrieving Windows Updates..."
    #Get-WindowsUpdate -- Auskommentiert zu testing Zwecken.
    Write-Host -ForegroundColor Green "Successfully retrieved Windows Updates."
} catch {
    Write-Host -ForegroundColor Red "Failed to retrieve or verify Windows Updates: $_"
    pause
    exit
}
try {
    Write-Host -ForegroundColor Yellow "Installing Windows Updates..."
    #Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot  -- Auskommentiert zu testing Zwecken.
    Write-Host -ForegroundColor Green "Successfully installed Windows Updates."
} catch {
    Write-Host -ForegroundColor Red "Failed to install or verify Windows Updates: $_"
    pause
    exit
}



#ST Script zum anpassen der Taskleiste für alle Benutzer.
$provisioningFolder = "$env:ProgramData\Microsoft\Windows\Taskbar"
$provisioningFile = "$provisioningFolder\taskbar_layout.xml"

$taskbar_layout = @"
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>
        <taskbar:DesktopApp DesktopApplicationLinkPath="$env:SystemDrive\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" />
        <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Program Files\Mozilla Firefox\firefox.exe" />
        <taskbar:DesktopApp DesktopApplicationLinkPath="C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" />
      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
 </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
try {
    Write-Host -ForegroundColor Yellow "Pinning Applications to taskbar..."
    if (-not (Test-Path -Path $provisioningFolder)) {
        New-Item -ItemType Directory -Path $provisioningFolder -Force
    }
    $taskbar_layout | Out-File -FilePath $provisioningFile -Encoding utf8
    $settings = [PSCustomObject]@{
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Name  = "StartLayoutFile"
        Value = $provisioningFile
        Type  = [Microsoft.Win32.RegistryValueKind]::ExpandString
    },
    [PSCustomObject]@{
        Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Name  = "LockedStartLayout"
        Value = 1
        Type  = [Microsoft.Win32.RegistryValueKind]::DWord
    } | Group-Object Path

    foreach ($settingGroup in $settings) {
        $registryPath = $settingGroup.Name
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }
        foreach ($setting in $settingGroup.Group) {
            Set-ItemProperty -Path $registryPath -Name $setting.Name -Value $setting.Value -Type $setting.Type
        }
    }
} catch {
    Write-Host -ForegroundColor Red "Failed to pin Applications to Taskbar: $_"
    pause
}
Write-Host -ForegroundColor Green "Successfully pinned Applications to taskbar for all users. Reboot required to see effects."





#ST Script zum anpassen von Registry Keys für die Taskbar
$widgetsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
$taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$chatPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
try {
    Write-Host -ForegroundColor Yellow "Applying Taskbar Registry keys..."
    Set-ItemProperty -Path $widgetsPath -Name "TaskbarDa" -Value 0
    Set-ItemProperty -Path $searchPath -Name "SearchboxTaskbarMode" -Value 1
    Set-ItemProperty -Path $taskbarPath -Name "ShowTaskViewButton" -Value 0
    Set-ItemProperty -Path $chatPath -Name "TaskbarMn" -Value 0
    Write-Host -ForegroundColor Green "Registry Keys successfully set."
} catch {
    Write-Host -ForegroundColor Red "Failed to apply Taskbar Registry keys: $_"
    pause
}

#ST Script zum löschen von Microsoft Edge Shortcut
try {
    Write-Host -ForegroundColor Yellow "Deleting Microsoft Edge Desktop Shortcut..."
    $desktopPath = [System.Environment]::GetFolderPath('Desktop')
    $shortcutName = "Microsoft Edge.lnk"
    $shortcutPath = Join-Path -Path $desktopPath -ChildPath $shortcutName
    if (Test-Path -Path $shortcutPath) {
        Remove-Item -Path $shortcutPath
        Write-Host -ForegroundColor Green "Microsoft Edge shortcut has been deleted from the desktop."
    } else {
        Write-Host -ForegroundColor Yellow "Microsoft Edge shortcut does not exist on the desktop."
    }
} catch {
    Write-Host -ForegroundColor Red "Failed to delete Microsoft Edge Desktop Shortcut: $_"
    pause    
}

#ST Script zum dekativieren von autologon
try {
    Write-Host -ForegroundColor Yellow "Disabling Autologon..."
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -Path $registryPath -Name "AutoAdminLogon" -Value "0"
    Remove-ItemProperty -Path $registryPath -Name "DefaultUserName"
    Remove-ItemProperty -Path $registryPath -Name "DefaultPassword"
    Write-Host -ForegroundColor Green "Autologon disabled."
} catch {
    Write-Host -ForegroundColor Red "Failed to disable Autologon: $_"   
    pause 
}

#ST Script zum löschen von der aufgabe
try {
    Write-Host -ForegroundColor Yellow "Deleting Init User Script scheduled Task..."
    $task = Get-ScheduledTask -TaskName 'InitUserScript' -ErrorAction Stop
    if ($task) {
        Unregister-ScheduledTask -TaskName 'InitUserScript' -Confirm:$false
        Write-Host -ForegroundColor Green "Scheduled task 'InitUserScript' has been deleted."
    }
} catch {
    Write-Host -ForegroundColor Red "Scheduled task 'InitUserScript' does not exist or could not be found."
    pause
}

try {
    Write-Host -ForegroundColor Yellow "Restarting Windows Explorer..."
    Stop-Process -Name explorer -Force
    Start-Process explorer
    Write-Host -ForegroundColor Green "Windows Explorer successfully restarted."
} catch {
    Write-Host -ForegroundColor Red "Failed to restart Windows explorer: $_"
}

pause