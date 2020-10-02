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

.EXAMPLE
  .\ForceWindowsUpdate.ps1

#>

# Aanmaken standaard logpath (als deze nog niet bestaat)
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
	Get-WindowsUpdate -AcceptAll -Download -Install
	Write-Output "----- Ready"
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
