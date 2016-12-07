<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used connect to a vCenter server and get a list of ESX hosts managed by that vCenter server and output
    the list of ESX hosts as a .txt file to a specified location
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER outfile
    Location and filename of the resultant list of ESX hosts in .txt format
.EXAMPLE
./CreateESXHostList.ps1 -viserver vCenterServer01.domain.com -outfile C:\temp\esxhostlist.txt
#> 

Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )

# Import the VMWare modules into vanilla powershell
Import-Module VMWare.vimautomation.cis.core
Import-Module VMWare.vimautomation.cloud
Import-Module VMWare.vimautomation.core
Import-Module VMWare.vimautomation.ha
Import-Module VMWare.vimautomation.pcloud
Import-Module VMWare.vimautomation.sdk
Import-Module VMWare.vimautomation.storage
Import-Module VMWare.vimautomation.vds

# Disconnect from any currently connected vCenter or ESX servers
Disconnect-VIServer * -confirm:$false

# Connect to the vCenter server specified when the script was launched
Connect-VIServer $viserver

# Query that vCenter server for a list of all ESX hosts it manages and take only the names of those servers and write
# to a text file with a name and location specified by the value entered for $outfile
Get-VMHost | foreach { $_.Name } | out-file -Append $outfile

# Disconnect from the ESX host
Disconnect-VIServer * -confirm:$false