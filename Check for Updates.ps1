<#   
.SYNOPSIS    

Base Script- use this as a foundation for all future code

.DESCRIPTION  
Base Script- use this as a foundation for all future code

.NOTES    
Name: FP_Powershell_Base.ps1  
Author: Damon Beckwitt 

DateCreated: March 26, 2021   
    
.LINK    
  

.CHANGELOG
7.19.21 Added Start-Transcript logging
            
#>  


Clear-host
#Base Variables - common to all FP Scripts
$Date = (get-date)
$FPPath = "C:\FedPro"
$LogFile = "C:\FedPro\log.txt"
$ExitCode = 0
$MinOSBuild = 0 #9600
$TSDate = Get-Date -format MMddyy


#Script Variables - local to this script.



#Make sure we're running as admin
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}

<#Function to write to both screen and log.
    Usage Write-Log "something cool is happening now"
    if passing a system variable, use $NewVar = @(Get-Variable -ValueOnly CurrentVar) and pass that variable to the function
#>
function write-log ($info){
    $Date = (get-date)
    "$Date`t$info" | add-content $logfile
    Write-Host $info
    }

#Error if unsupported Windows version
if([system.environment]::OSVersion.Version.Build -lt $MinOSBuild){
    Write-Log "Windows version is unsupported.  Upgrade to a currently supported OS"
    $exitcode = 3
    exit $exitcode
    }

#Make sure we can write to the disk
if(!(Test-Path $FPPath -PathType Container)){
    New-Item -ItemType Directory -Path $FPPath
    write-log "Logfile Created"
    }

if(!(Test-Path $FPPath\PSTranscripts)) {
    New-Item -ItemType Directory -Path $FPPath\PSTranscripts
}   

Start-Transcript -Append -Path $FPPath\PSTranscripts\$TSDate.Log

<#
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
                                                                        ADD NEW CODE BELOW THIS COMMENT SECTION
#>
#Display past updates that have been installed
get-wmiobject -class win32_quickfixengineering | Sort-Object InstalledOn | Format-Table Description, HotFixID, InstalledOn

write-host "^^^^ Most recently installed updates are listed above ^^^^"

#If statement to check if PSWindowsUpdate is already installed.
$InstalledModule = Get-InstalledModule -Name PSWindowsUpdate

if ($InstalledModule = "PSWindowsUpdate")
{
#Display Windows Updates that are available
Get-WindowsUpdate | Format-Table HotFixID, Title

write-host "^^^^ Updates that can be installed are listed above ^^^^"
}
else
{
#Install correct modules to show available updates
Install-Module -Name PSWindowsUpdate -force
Import-Module -Name PSWindowsUpdate

#Display Windows Updates that are available
Get-WindowsUpdate | Format-Table HotFixID, Title

write-host "^^^^ Updates that can be installed are listed above ^^^^"
}

<#
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________________________________________________________
                                                                        ADD NEW CODE ABOVE THIS COMMENT SECTION
#>