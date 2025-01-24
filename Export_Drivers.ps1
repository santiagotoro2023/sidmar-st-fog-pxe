# Check if the ImportExcel module is installed, install if not
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "The ImportExcel module is not installed. Installing now..."
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Import the module
Import-Module ImportExcel

# Get driver information
$drivers = Get-WmiObject Win32_PnPSignedDriver | 
    Select-Object DeviceName, Manufacturer, DriverDate

# Format driver information
$formattedDrivers = foreach ($driver in $drivers) {
    $readableDate = if ($driver.DriverDate -ne $null) {
        [System.Management.ManagementDateTimeConverter]::ToDateTime($driver.DriverDate).ToString("yyyy-MM-dd")
    } else {
        "N/A"
    }

    [PSCustomObject]@{
        "Device Name"  = $driver.DeviceName
        "Manufacturer" = $driver.Manufacturer
        "Driver Date"  = $readableDate
    }
}

# Define the file path for the Excel file
$excelFilePath = "$env:USERPROFILE\Desktop\DriversInfo.xlsx"

# Export data to Excel
$formattedDrivers | Export-Excel -Path $excelFilePath -AutoSize -WorksheetName 'Drivers'

Write-Host "Data successfully exported to $excelFilePath"
