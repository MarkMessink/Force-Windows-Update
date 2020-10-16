<#
.SYNOPSIS
    Force Windows Defender Powershell script
	Mark Messink 16-10-2020

.DESCRIPTION
 
.INPUTS
  None

.OUTPUTS
  Log file: pslog_ForceDefenderUpdate.txt
  
.NOTES
  

.EXAMPLE
  .\ForceDefenderUpdate.ps1
#>

# Create Default Intune Log folder (is not exist)
$path = "C:\IntuneLogs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$logPath = "$path\pslog_ForceDefenderUpdate.txt"

#Start logging
Start-Transcript $logPath -Append -Force

	Write-Output "-------------------------------------------------------------------"
	Write-Output "----- Check Defender Versions"
	Get-MpComputerStatus | select *updated, *version
	
	Write-Output "----- Update Defender"
	Update-MpSignature
	
	Write-Output "----- Check New Defender Versions"
	Get-MpComputerStatus | select *updated, *version
		
    Write-Output "-------------------------------------------------------------------"

#Stop Logging
Stop-Transcript
