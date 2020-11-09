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
  Log file: pslog_ForceWindowsBuildUpdate_<build>.txt
  
.NOTES
  Executing this script may take a long time to finish
  1903 = 10.0.18362.0
  1909 = 10.0.18363.0
  2004 = 10.0.19041.0
  20H2 = 10.0.19042.0
  21H1 - 10.0.20231.0 (Insider preview DEV)

.EXAMPLE
  .\ForceWindowsBuildUpdate.ps1
#>

# Buildnumber to update to:
$buildnumber = "10.0.18363.0"

# Create Default Intune Log folder (is not exist)
$path = "C:\IntuneLogs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$logPath = "$path\pslog_ForceWindowsBuildUpdate_$buildnumber.txt"

#Start logging
Start-Transcript $logPath -Append -Force

	Write-Output "-------------------------------------------------------------------"
	Write-Output "----- Check version Windows"
	$version = [system.environment]::OSversion.version
	Write-Output "----- Windows version = $version"
	if ($version -lt "$buildnumber") { 
		Write-Output "----- Install NuGet Provider"
		Install-PackageProvider -Name NuGet -MinimumVersion "2.8.5.201" -Force #-Verbose
		Write-Output "----- Install Module PSWindowsUpdate"
		Install-Module -Name PSWindowsUpdate -Force #-Verbose
		Write-Output "----- Import module PSWindowsUpdate"
		import-module PSWindowsUpdate #-Verbose
		Write-Output "----- Accept, Download and Install Windows Updates (noReboot)"
		<#
		1909=KB4577671
		2004=KB4579311 
		20H2=KB4562830
		#>
		
		Get-WindowsUpdate -KBArticle "KB4577671", "KB4579311", "KB4562830" -AcceptAll -Download -Install -IgnoreReboot | FT Result, KB, Title
	}
	else {
	Write-Output ""
	Write-Output "----- No updates installed."
	}
	
    Write-Output "-------------------------------------------------------------------"
	

#Stop Logging
Stop-Transcript
