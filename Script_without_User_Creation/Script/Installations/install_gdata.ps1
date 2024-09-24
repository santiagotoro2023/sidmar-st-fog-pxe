#STAND 05.09.2024: WARTEN AUF CHRISTOPH FOG GDATA DATEI.

Write-Host -ForegroundColor Yellow "Starting 'InitGDATA' scheduled task..."

#$url = "https://sidmar.iwaycloud.ch/remote.php/webdav/MES%20Installation/xxxxxxxxxxxxx.exe"
#$destination = "C:\Users\SIDMAR\Downloads\xxxxxxxxxx.exe"

# Define the credentials
#$username = "download@sidmar.ch"
#$password = "g.v-GHjcr9hR"
#$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)
Write-Host -ForegroundColor Yellow "Downloading GDATA Antivirus (FOG) installer..."
#$webClient = New-Object System.Net.WebClient
#$webClient.Credentials = New-Object System.Net.NetworkCredential($username, $securePassword)

try {
#   $webClient.DownloadFile($url, $destination)
    Write-Host -ForegroundColor Green "GDATA Antivirus (A+B) installer downloaded."
} catch {
    Write-Host -ForegroundColor Red "Failed to download GDATA Antivirus (A+B) installer: $_"
    pause
}

Write-Host -ForegroundColor Yellow "Starting installer..."
#Start-Process -FilePath $destination -ArgumentList '/_QuietInstallation="true"' -Wait
Write-Host -ForegroundColor Green "GDATA Antivirus (FOG) successfully installed. A Reboot may be required."

# Optionally remove the installer after installation
# Remove-Item -Path $destination

Write-Host -ForegroundColor Yellow "Deleting initGDATA scheduled task..."
try {
    # Check if the task exists
    $task = Get-ScheduledTask -TaskName 'InitGDATA' -ErrorAction Stop
    if ($task) {
        # Unregister (delete) the scheduled task
        Unregister-ScheduledTask -TaskName 'InitGDATA' -Confirm:$false
        Write-Host -ForegroundColor Green "Scheduled task 'initGDATA' has been deleted."
    }
} catch {
    Write-Host -ForegroundColor Red "Scheduled task 'InitGDATA' does not exist or could not be found."
    pause
}

pause