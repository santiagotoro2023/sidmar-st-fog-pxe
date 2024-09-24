Write-Host -ForegroundColor Yellow "Starting 'initFastviewer' scheduled task..."

$url = "https://sidmar.iwaycloud.ch/remote.php/webdav/Fastviewer/fvwresetup_3-25-0001.exe"
$destination = "C:\Users\SIDMAR\Downloads\fvwresetup_3-25-0001.exe"

# Define the credentials
$username = "download@sidmar.ch"
$password = "g.v-GHjcr9hR"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)
Write-Host -ForegroundColor Yellow "Downloading FastViewer installer..."
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($username, $securePassword)

try {
    $webClient.DownloadFile($url, $destination)
    Write-Host -ForegroundColor Green "FastViewer installer downloaded."
} catch {
    Write-Host -ForegroundColor Red "Failed to download FastViewer installer: $_"
    pause
}

Write-Host -ForegroundColor Yellow "Starting installer..."
Start-Process -FilePath $destination -ArgumentList '/silent' -Wait
Write-Host -ForegroundColor Green "FastViewer successfully installed. A Reboot may be required."

# Optionally remove the installer after installation
# Remove-Item -Path $destination


Write-Host -ForegroundColor Yellow "Deleting initFastviewer scheduled task..."
try {
    # Check if the task exists
    $task = Get-ScheduledTask -TaskName 'initFastviewer' -ErrorAction Stop
    if ($task) {
        # Unregister (delete) the scheduled task
        Unregister-ScheduledTask -TaskName 'initFastviewer' -Confirm:$false
        Write-Host -ForegroundColor Green "Scheduled task 'initFastviewer' has been deleted."
    }
} catch {
    Write-Host -ForegroundColor Red "Scheduled task 'initFastviewer' does not exist or could not be found."
    pause
}

pause