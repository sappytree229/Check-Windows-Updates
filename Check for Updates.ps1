#Made by Noah Lawson

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        # Relaunch as an elevated process:
        Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
        exit
    }

function Get-WindowsUpdateModuleInstallationStatus
{
    #If statement to check if PSWindowsUpdate is already installed.
    $InstalledModule = Get-InstalledModule -Name PSWindowsUpdate

if ($InstalledModule = "PSWindowsUpdate")
{
    Get-UpdateHistory
    Get-CurrentAvailableUpdates
}
else
{
    $Count = 0

    Get-WindowsUpdateModule

    $Count++

    If ($Count = 4)
    {
        write-host "This is not working. Sorry!"
        exit
    }

    sleep 5

    Get-WindowsUpdateModuleInstallationStatus
}
}

function Get-WindowsUpdateModule
{
    #Install correct modules to show available updates
    Install-Module -Name PSWindowsUpdate -force
    Import-Module -Name PSWindowsUpdate
}

function Get-UpdateHistory
{
#Display past updates that have been installed
get-wmiobject -class win32_quickfixengineering | Sort-Object InstalledOn | Format-Table Description, HotFixID, InstalledOn

write-host "^^^^ Most recently installed updates are listed above ^^^^"
}

function Get-CurrentAvailableUpdates
{
#Display Windows Updates that are available
Get-WUServiceManager | Format-Table Name, ServiceID

write-host "^^^^ Updates that can be installed are listed above ^^^^"
}

function Get-UserInputForUpdates
{
    write-host 

    $WouldYouLikeToUpdate = read-host -prompt "Would you like to install all currently available updates? Enter yes or no"

    if ($WouldYouLikeToUpdate -eq "yes")
    {
        Install-WindowsUpdate -AcceptAll -AutoReboot
    }
    else
    {
        write-host "Goodbye!"
        sleep 5
        exit
    }

}

Set-ExecutionPolicy Bypass
Get-WindowsUpdateModuleInstallationStatus
Get-UserInputForUpdates






