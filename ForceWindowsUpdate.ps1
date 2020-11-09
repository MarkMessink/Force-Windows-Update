<#
.SYNOPSIS
   Force Windows Update Powershell script
	Mark Messink 16-10-2020
	
	info: https://www.powershellgallery.com/packages/PSWindowsUpdate/
	
	Check buildnumbers: https://docs.microsoft.com/en-us/windows/release-information/


.DESCRIPTION
	This script updates Windows when buildnumber is to low
	 - Intune minimum operating system
	 - Intune device enrollment restrictions

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
  20H2 = 19042
  21H1 - 20231 (DEV)

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
	Install-PackageProvider -Name NuGet -RequiredVersion "2.8.5.201" -Force -Verbose
	Write-Output "----- Install PSWindowsUpdate"
	Install-Module -Name PSWindowsUpdate -Force -Verbose
	Write-Output "----- Install Windows Updates (no reboot)"
	Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot | FT
	Write-Output "----- Check new version Windows"
	}
	else {
	Write-Output ""
	Write-Output "----- No updates installed."
	}
	
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
