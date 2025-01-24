# Ensure the ImportExcel module is available
Import-Module ImportExcel

$drivers = Get-WmiObject Win32_PnPSignedDriver | 
    Select-Object DeviceName, Manufacturer, DriverDate

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

# Export to Excel file
$excelFilePath = "$env:USERPROFILE\Downloads\DriversInfo.xlsx"
$formattedDrivers | Export-Excel -Path $excelFilePath -AutoSize -WorksheetName 'Drivers'

Write-Host "Data successfully exported to $excelFilePath"
