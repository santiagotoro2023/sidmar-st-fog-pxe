function Set-RegistryKey {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type,
        [int]$Value
    )
    
    if (!(Test-Path $Path)) {
        Write-Host "Creating path $Path..." -ForegroundColor Yellow
        New-Item -Path $Path -Force | Out-Null
    }
    
    Write-Host "Setting $Name key in $Path..." -ForegroundColor Yellow
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
    Write-Host "$Name key successfully set to $Value." -ForegroundColor Green
}

# Set AppAutoUpdate to 1
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "AppAutoUpdate" -Type "DWord" -Value 1

# Set DisablePocket to 1
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "DisablePocket" -Type "DWord" -Value 1

# Set DisableTelemetry to 1
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "DisableTelemetry" -Type "DWord" -Value 1

# Set Customize Firefox Home to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "CustomizeFirefoxHome" -Type "DWord" -Value 0

# Set Search to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Search" -Type "DWord" -Value 0

# Set TopSites to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "TopSites" -Type "DWord" -Value 0

# Set Highlights to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Highlights" -Type "DWord" -Value 0

# Set Pocket to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Pocket" -Type "DWord" -Value 0

# Set Snippets to 0
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Snippets" -Type "DWord" -Value 0

# Set NoDefaultBookmarks to 1
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "NoDefaultBookmarks" -Type "DWord" -Value 1

# Don't allow settings to be changed
Set-RegistryKey -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Locked" -Type "DWord" -Value 1

# Add Extensions
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install")) {
    Write-Host "Creating path HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install..." -ForegroundColor Yellow
    New-Item -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" -Force | Out-Null
}
Write-Host "Setting Extensions key..." -ForegroundColor Yellow
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" -Name "1" -Value "https://addons.mozilla.org/firefox/downloads/file/4237670/ublock_origin-1.56.0.xpi" -PropertyType "ExpandString" -Force | Out-Null
Write-Host "Extensions key successfully set." -ForegroundColor Green

# Force Group Policy Update
Write-Host "Forcing Group Policy update..." -ForegroundColor Yellow
gpupdate /force
Write-Host "Group Policy update complete." -ForegroundColor Green

# Pause the script
Write-Host "Script completed. Press Enter to exit." -ForegroundColor Yellow
Read-Host -Prompt "Press Enter to continue"
