$TextFilePath = Read-Host "What is the path to the computer list text file?"
$OutputCSVFilePath = Read-Host "Where do you want to save the CSV files (path)?"
$SystemCSVPath = Join-Path $OutputCSVFilePath "system_information.csv"
$ServiceCSVPath = Join-Path $OutputCSVFilePath "service_information.csv"

If (Test-Path $TextFilePath) {
    $ComputersArray = Get-Content $TextFilePath

    $SystemInformation = ForEach ($Computer in $ComputersArray) {
        If (Test-Connection $Computer -Count 1) {
            $System = Get-WmiObject Win32_ComputerSystem -ComputerName $Computer | Select-Object -Property Name, Model
            $BIOS = Get-WmiObject Win32_BIOS -ComputerName $Computer | Select-Object -Property SerialNumber
            [PSCustomObject]@{
                ComputerName = $Computer
                Name         = $System.Name
                Model        = $System.Model
                SerialNumber = $BIOS.SerialNumber
            }
        }
        Else {
            Write-Host("$Computer appears to be offline.")
        }
    }
    Write-Host("Saving SystemInformation CSV file in the location", $SystemCSVPath)
    $SystemInformation | Export-Csv -Path $SystemCSVPath -NoTypeInformation
  
    $ServiceInformation = ForEach ($Computer in $ComputersArray) {
        If (Test-Connection $Computer -Count 1) {
            $Service = Get-Service LanmanWorkstation | Select-Object -property name, status
            $Mode = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='LanmanWorkStation'" | Select-Object -property StartMode
            [PSCustomObject]@{
                ComputerName      = $Computer
                WorkstationStatus = $Service.Status
                StartupMode       = $Mode.StartMode
            }
        }
        Else {
            Write-Host("$Computer appears to be offline.")
        }
    }
    Write-Host("Saving ServiceInformation CSV file in the location", $SystemCSVPath)
    $ServiceInformation |Export-Csv -Path $ServiceCSVPath -NoTypeInformation
}
Else {
    Write-Error "The text file was not found, please check the path."
}
