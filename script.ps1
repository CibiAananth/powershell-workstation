# Get the path to text file from the user and store it in the variable TextFilePath
$TextFilePath = Read-Host "What is the path to the computer list text file?"
# Get the path to output csv from the user file and store it in the variable OutputCSVFilePath
$OutputCSVFilePath = Read-Host "Where do you want to save the CSV files (path)?"
# Append the path and output csv filenames
$SystemCSVPath = Join-Path $OutputCSVFilePath "system_information.csv"
$ServiceCSVPath = Join-Path $OutputCSVFilePath "service_information.csv"

# Check if the text file exists in the given location
If (Test-Path $TextFilePath) {
    # read the contens of the text file and store in a vaiable
    $ComputersArray = Get-Content $TextFilePath
    # loop through the computer list and store the system information in the SystemInformation variable
    $SystemInformation = ForEach ($Computer in $ComputersArray) {
        # check if the computer is online
        If (Test-Connection $Computer -Count 1) {
            # get the Computer make and model
            $System = Get-WmiObject Win32_ComputerSystem -ComputerName $Computer | Select-Object -Property Manufacturer, Model
            # get the Computer serial number
            $BIOS = Get-WmiObject Win32_BIOS -ComputerName $Computer | Select-Object -Property SerialNumber
            # store the computer make, model and serial numbre in a Object
            [PSCustomObject]@{
                ComputerName = $Computer
                Manufacturer = $System.Manufacturer
                Model        = $System.Model
                SerialNumber = $BIOS.SerialNumber
            }
        }
        # display error messge to the user if the computer is offline
        Else {
            Write-Error("$Computer appears to be offline.")
        }
    }
    # Write the output of SystemInformation array to csv file in the given path
    Write-Host("Saving SystemInformation CSV file in the location", $SystemCSVPath)
    $SystemInformation | Export-Csv -Path $SystemCSVPath -NoTypeInformation
 
 
    # loop through the computer list and store the service information in the ServiceInformation variable
    $ServiceInformation = ForEach ($Computer in $ComputersArray) {
        # check if the computer is online
        If (Test-Connection $Computer -Count 1) {
            # get the workstation service status
            $Service = Get-Service LanmanWorkstation | Select-Object -property status
            # get the startup mode of the workstation service
            $Mode = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='LanmanWorkStation'" | Select-Object -property StartMode
            # store the computer workstation service status and startup mode in a Object
            [PSCustomObject]@{
                ComputerName      = $Computer
                WorkstationStatus = $Service.Status
                StartupMode       = $Mode.StartMode
            }
        }
        # display error messge to the user if the computer is offline
        Else {
            Write-Host("$Computer appears to be offline.")
        }
    }
    # Write the output of ServiceInformation array to csv file in the given path
    Write-Host("Saving ServiceInformation CSV file in the location", $SystemCSVPath)
    $ServiceInformation |Export-Csv -Path $ServiceCSVPath -NoTypeInformation
}
# display error messge to the user if the text file was not found
Else {
    Write-Error "The text file was not found, please check the path."
}
