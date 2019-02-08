$TextFilePath = Read-Host "What is the path to the text file?"
If (Test-Path $TextFilePath) {
    $ComputersArray = Get-Content $TextFilePath
    ForEach ($Computer in $ComputersArray) {
        If (Test-Connection $Computer -Count 1) {
            Write-Host($Computer)
            Invoke-Command -ComputerName $Computer {dir c:/}
        }
        Else {
            Write-Host("$Computer appears to be offline.")
        }
    }
}
Else {
    Write-Error "The text file  was not found, check the path."
}