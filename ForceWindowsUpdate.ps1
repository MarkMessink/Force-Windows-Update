<#
.SYNOPSIS
    Force Windows Update Powershell script
	Mark Messink 16-10-2020

.DESCRIPTION
	This script updates Windows when buildnumber is to low


 
.INPUTS
  None

.OUTPUTS
  Log file: pslog_ForceWindowsUpdate_<build>.txt
  
.NOTES
  Executing this script may take a long time to finish
  Check buildnumbers --> https://docs.microsoft.com/en-us/windows/release-information/
  1903 = 18362
  1909 = 18363
  2004 = 19041
  2009 = 19042
  21H1 - 20231 (Insider preview DEV)

.EXAMPLE
  .\ForceWindowsUpdate.ps1
#>

# Buildnumber to update to:
$buildnumber = "19041"

# Create Default Intune Log folder (is not exist)
$path = "C:\IntuneLogs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$logPath = "$path\pslog_ForceWindowsUpdate_$buildnumber.txt"

#Start logging
Start-Transcript $logPath -Append -Force

	Write-Output "-------------------------------------------------------------------"
	Write-Output "----- Check version Windows"
	$version = [system.environment]::OSversion.version.build
	Write-Output "----- Windows version = $version"
	if ($version -lt "$buildnumber") {    
	Write-Output "----- Install NuGet Provider"
	Install-PackageProvider -Name NuGet -Force
	Write-Output "----- Install PSWindowsUpdate"
	Install-Module -Name PSWindowsUpdate -Force
	Write-Output "----- Install Windows Updates (no reboot)"
	Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot | FT
	Write-Output "----- Check new version Windows"
	$version_new = [system.environment]::OSversion.version
	Write-Output "----- New Windows version = $version_new"
	}
	else {
	Write-Output ""
	Write-Output "----- No updates installed."
	}
	
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
