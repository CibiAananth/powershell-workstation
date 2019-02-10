# Powershell script

Powershell script to read the computer list from a text file and get the make, model, serial number and workstation service status and startup mode

The given script assumes the following

1. PSRemoting is enabled in the machine. If not enable it by typing `Enable-PSRemoting -SkipNetworkProfileCheck -Force` in the Powershell
2. The execution policy is enabled to run the Powershell scripts downloaded from the internet. If not enable it by typing `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` in the Powershell
3. The computer list text file is available in the machine. If not use the text file in the repository by typing `./computer-list.txt` when prompted to enter the path to file.
4. Each computer name is saved in a new line without any `,`
