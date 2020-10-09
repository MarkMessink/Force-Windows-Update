<#
.SYNOPSIS
    Force Windows Update Powershell script
	Mark Messink 02-10-2020

.DESCRIPTION
 
.INPUTS
  None

.OUTPUTS
  Log file: ilog_ps_ForceWindowsUpdate_<build>.txt
  
.NOTES
  Executing this script may take a long time to finish
  Check buildnumbers --> https://docs.microsoft.com/en-us/windows/release-information/
  1903 = 18362
  1909 = 18363
  20H1 = 19041
  20H2 = 19042
  21H1 - 20201 (Insider preview DEV)

.EXAMPLE
  .\ForceWindowsUpdate.ps1

#>

# Create Default Intune Log folder (is not exist)
$path = "C:\IntuneLogs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$logPath = "$path\ilog_ps_ForceWindowsUpdate_18362.txt"

#Start logging
Start-Transcript $logPath -Append -Force

	Write-Output "-------------------------------------------------------------------"
	Write-Output "----- Check version Windows"
	$version = [system.environment]::OSversion.version.build
	Write-Output "----- Windows version = $version"
	if ($version -lt "18362") {    
	Write-Output "----- Install NuGet Provider"
	Install-PackageProvider -Name NuGet -Force
	Write-Output "----- Install PSWindowsUpdate"
	Install-Module -Name PSWindowsUpdate -Force
	Write-Output "----- Install Windows Updates"
	Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot | FT
	Write-Output "----- Ready"
	}
	else {
	Write-Output "----- No updates installed, Windows 10 Version = $version"
	}
	
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
