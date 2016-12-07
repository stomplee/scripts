<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used query the VMWare tools status of all virtual machines managed by a given vCenter or ESX server
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against
.PARAMETER outfile
    Path and filename to output the results to in .CSV format
.EXAMPLE
./GetVMWareToolsStatus.ps1 -viserver vCenterServer01.domain.com -outfile c:\temp\toolsstatusresults.csv
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )

# Import the required VMWare modules into vanilla powershell    
Import-Module VMWare.vimautomation.cis.core
Import-Module VMWare.vimautomation.cloud
Import-Module VMWare.vimautomation.core
Import-Module VMWare.vimautomation.ha
Import-Module VMWare.vimautomation.pcloud
Import-Module VMWare.vimautomation.sdk
Import-Module VMWare.vimautomation.storage
Import-Module VMWare.vimautomation.vds

# Disconnect from all vCenter and ESX hosts
Disconnect-VIServer * -Confirm:$false

# Connect to the server specifed by $viserver when the script was first launched
Connect-VIServer $viserver


# Run a loop against every virtual machine hosted by $viserver and query the VMWare tools status of each VM and export the results to a .CSV
# file specified by $outfile
Get-VM | Where-Object {$_.PowerState -eq "PoweredOn"} | Get-View | Select-Object @{N=”VMName”;E={$_.Name}},@{Name=”VMware Tools”;E={$_.Guest.ToolsStatus}} | Export-CSV -append -notype $outfile

# Disconnect from the server specified by $viserver
Disconnect-VIServer $viserver -Confirm:$false