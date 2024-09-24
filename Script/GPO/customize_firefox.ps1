# Set AppAutoUpdate to 1
Write-Host "Setting AppAutoUpdate key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "AppAutoUpdate" -Value 1 -Type DWord -Force
Write-Host "AppAutoUpdate key successfully set." -ForegroundColor Green

# Set DisablePocket to 1
Write-Host "Setting DisablePocket key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "DisablePocket" -Value 1 -Type DWord -Force
Write-Host "DisablePocket key successfully set." -ForegroundColor Green

# Set DisableTelemetry to 1
#Write-Host "Setting DisableTelemetry key..." -ForegroundColor Yellow
#Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "DisableTelemetry" -Value 1 -Type DWord -Force
#Write-Host "DisableTelemetry key successfully set." -ForegroundColor Green

# Set Customize Firefox Home to 0
#Write-Host "Setting CustomizeFirefoxHome key..." -ForegroundColor Yellow
#New-Item -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Force | Out-Null
#Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "CustomizeFirefoxHome" -Value 0 -Type DWord -Force
#Write-Host "CustomizeFirefoxHome key successfully set." -ForegroundColor Green

## Set Search to 0
#Write-Host "Setting Search key..." -ForegroundColor Yellow
#Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Search" -Value 0 -Type DWord -Force
#Write-Host "Search key successfully set." -ForegroundColor Green

# Set TopSites to 0
Write-Host "Setting TopSites key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "TopSites" -Value 0 -Type DWord -Force
Write-Host "TopSites key successfully set." -ForegroundColor Green

# Set Highlights to 0
Write-Host "Setting Highlights key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Highlights" -Value 0 -Type DWord -Force
Write-Host "Highlights key successfully set." -ForegroundColor Green

# Set Pocket to 0
Write-Host "Setting Pocket key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Pocket" -Value 0 -Type DWord -Force
Write-Host "Pocket key successfully set." -ForegroundColor Green

# Set Snippets to 0
Write-Host "Setting Snippets key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Snippets" -Value 0 -Type DWord -Force
Write-Host "Snippets key successfully set." -ForegroundColor Green

# Set NoDefaultBookmarks to 1
Write-Host "Setting NoDefaultBookmarks key..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox" -Name "NoDefaultBookmarks" -Value 1 -Type DWord -Force
Write-Host "NoDefaultBookmarks key successfully set." -ForegroundColor Green

# Don't allow settings to be changed
#Write-Host "Setting Locked key..." -ForegroundColor Yellow
#Set-ItemProperty -Path "HKLM:\Software\Policies\Mozilla\Firefox\FirefoxHome" -Name "Locked" -Value 1 -Type DWord -Force
#Write-Host "Locked key successfully set." -ForegroundColor Green

# Add Extensions
Write-Host "Setting Extensions key..." -ForegroundColor Yellow
New-Item -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" -Name "1" -Value "https://addons.mozilla.org/firefox/downloads/file/4237670/ublock_origin-1.56.0.xpi" -Type ExpandString -Force
Write-Host "Extensions key successfully set." -ForegroundColor Green

# Force Group Policy Update
Write-Host "Forcing Group Policy update..." -ForegroundColor Yellow
gpupdate /force
Write-Host "Group Policy update complete." -ForegroundColor Green

# Pause the script
Write-Host "Script completed. Press Enter to exit." -ForegroundColor Yellow
Read-Host -Prompt "Press Enter to continue"
