<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to update VMWare tools on Windows virtual machines without rebooting them
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER inputfile
    Path to a file in .TXT format that contains a list of servers to update VMWare tools on
.EXAMPLE
./UpdateVMWareTools.ps1 -viserver vCenterServer01.domain.com -inputfile c:\temp\serverlist.txt
#> 

Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$inputfile
    )

# Import required VMWare modules into vanilla powershell
Import-Module VMWare.vimautomation.cis.core
Import-Module VMWare.vimautomation.cloud
Import-Module VMWare.vimautomation.core
Import-Module VMWare.vimautomation.ha
Import-Module VMWare.vimautomation.pcloud
Import-Module VMWare.vimautomation.sdk
Import-Module VMWare.vimautomation.storage
Import-Module VMWare.vimautomation.vds

# Disconnect from all vCenter and ESX servers
Disconnect-VIServer * -Confirm:$false

# Connect to server specified by $viserver
Connect-VIServer $viserver

# Load the list of servers specified by $inputlist into a variable for future processing
$inputlist = Get-Content $inputfile

# Loop through the input list of servers and check if they are Windows and if so then update VMWare tools without rebooting
foreach ($computer in $inputlist)
    {
    Get-VMGuest $computer | Where-Object {$_.OSFullName -like "*Windows*"} | Update-Tools -noreboot
    }