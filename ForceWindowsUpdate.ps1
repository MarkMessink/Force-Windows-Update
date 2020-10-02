<#
.SYNOPSIS
    Force Windows Update Powershell script
	Mark Messink 02-10-2020

.DESCRIPTION
 
.INPUTS
  None

.OUTPUTS
  Log file: ilog_ForceWindowsUpdate.txt
  
.NOTES
  Executing this script may take a long time to finish

.EXAMPLE
  .\ForceWindowsUpdate.ps1

#>

# Create Default Intune Log folder (is not exist)
$path = "C:\IntuneLogs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$logPath = "$path\ilog_ForceWindowsUpdate.txt"

#Start logging
Start-Transcript $logPath -Append -Force

	Write-Output "-------------------------------------------------------------------"
    Write-Output "----- Install NuGet Provider"
	Install-PackageProvider -Name NuGet -Force
	Write-Output "----- Install PSWindowsUpdate"
	Install-Module -Name PSWindowsUpdate -Force
	Write-Output "----- Install Windows Updates"
	Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot
	Write-Output "----- Ready"
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
