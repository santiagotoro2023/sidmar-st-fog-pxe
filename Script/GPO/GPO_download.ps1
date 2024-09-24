# Define URLs for Chrome and Firefox policy templates
$chromeDownloadUrl = "https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip"
$firefoxDownloadUrl = "https://github.com/mozilla/policy-templates/releases/download/v6.2/policy_templates_v6.2.zip"

# Define directories
$downloadDir = "$env:USERPROFILE\Downloads"
$chromeExtractDir = "$downloadDir\chrome_policy_templates"
$firefoxExtractDir = "$downloadDir\firefox_policy_templates_v6.2"
$policyDefinitionsDir = "C:\Windows\PolicyDefinitions"
$chromeLanguageDir = "$policyDefinitionsDir\en-US"
$firefoxLanguageDir = "$policyDefinitionsDir\en-US"

# Create directories if they don't exist
Write-Host -ForegroundColor Yellow "Creating required directories..."
New-Item -ItemType Directory -Path $chromeExtractDir -Force | Out-Null
New-Item -ItemType Directory -Path $firefoxExtractDir -Force | Out-Null
New-Item -ItemType Directory -Path $policyDefinitionsDir -Force | Out-Null
New-Item -ItemType Directory -Path $chromeLanguageDir -Force | Out-Null
New-Item -ItemType Directory -Path $firefoxLanguageDir -Force | Out-Null
Write-Host -ForegroundColor Green "Required directories successfully created."

# Download Chrome policy templates
Write-Host -ForegroundColor Yellow "Downloading Chrome policy templates..."
$chromeZipPath = "$downloadDir\chrome_policy_templates.zip"
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($chromeDownloadUrl, $chromeZipPath)
if (!(Test-Path $chromeZipPath)) {
    Write-Host -ForegroundColor Red "Error: Download failed for Chrome policy templates."
    pause
}
Write-Host -ForegroundColor Green "Chrome policy templates successfully downloaded."

# Extract Chrome policy templates
Write-Host -ForegroundColor Yellow "Extracting Chrome policy templates..."
Expand-Archive -Path $chromeZipPath -DestinationPath $chromeExtractDir -Force
Write-Host -ForegroundColor Green "Chrome policy templates successfully extracted."

# Copy ADMX files for Chrome
Write-Host -ForegroundColor Yellow "Copying ADMX files for Chrome..."
Copy-Item "$chromeExtractDir\windows\admx\chrome.admx" -Destination $policyDefinitionsDir -Force
Copy-Item "$chromeExtractDir\windows\admx\google.admx" -Destination $policyDefinitionsDir -Force
Write-Host -ForegroundColor Green "ADMX files for Chrome successfully copied."

# Copy ADML files for Chrome (English)
Write-Host -ForegroundColor Yellow "Copying ADML files for Chrome (English)..."
Copy-Item "$chromeExtractDir\windows\admx\en-US\chrome.adml" -Destination $chromeLanguageDir -Force
Copy-Item "$chromeExtractDir\windows\admx\en-US\google.adml" -Destination $chromeLanguageDir -Force
Write-Host -ForegroundColor Green "ADML files for Chrome (English) successfully copied."

# Download Firefox policy templates
Write-Host -ForegroundColor Yellow "Downloading Firefox policy templates..."
$firefoxZipPath = "$downloadDir\firefox_policy_templates_v6.2.zip"
$webClient.DownloadFile($firefoxDownloadUrl, $firefoxZipPath)
if (!(Test-Path $firefoxZipPath)) {
    Write-Host -ForegroundColor Red "Error: Download failed for Firefox policy templates."
    pause
}
Write-Host -ForegroundColor Green "Firefox policy templates successfully downloaded."

# Extract Firefox policy templates
Write-Host -ForegroundColor Yellow "Extracting Firefox policy templates..."
Expand-Archive -Path $firefoxZipPath -DestinationPath $firefoxExtractDir -Force
Write-Host -ForegroundColor Green "Firefox policy templates successfully extracted."

# Copy ADMX files for Firefox
Write-Host -ForegroundColor Yellow "Copying ADMX files for Firefox..."
Copy-Item "$firefoxExtractDir\windows\firefox.admx" -Destination $policyDefinitionsDir -Force
Copy-Item "$firefoxExtractDir\windows\mozilla.admx" -Destination $policyDefinitionsDir -Force
Write-Host -ForegroundColor Green "ADMX files for Firefox successfully copied."

# Copy ADML files for Firefox (English)
Write-Host -ForegroundColor Yellow "Copying ADML files for Firefox (English)..."
Copy-Item "$firefoxExtractDir\windows\en-US\firefox.adml" -Destination $firefoxLanguageDir -Force
Copy-Item "$firefoxExtractDir\windows\en-US\mozilla.adml" -Destination $firefoxLanguageDir -Force
Write-Host -ForegroundColor Green "ADML files for Firefox (English) successfully copied."

Write-Host "Script completed successfully." -ForegroundColor Green

gpupdate /force

pause

& "C:\Script\GPO\customize_firefox.ps1"