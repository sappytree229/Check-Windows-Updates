    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}

Set-ExecutionPolicy Bypass

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
