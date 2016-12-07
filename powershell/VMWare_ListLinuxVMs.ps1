<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to query a vCenter server and output CSV list containing the hostname, IP and OS type of
    any Linux machines it finds. You can change the value on line 40 for "*Linux*" to "*Windows*" if you wish
    to generate a list of Windows servers instead.
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER outfile
    Path and filename of the resultant CSV file
.EXAMPLE
./FindLinuxVM.ps1 -viserver vCenterServer01.domain.com -csvfile C:\temp\vmlist.csv
#> 

Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )

# Import the required VMWare modules for vanilla powershell
Import-Module VMWare.vimautomation.cis.core
Import-Module VMWare.vimautomation.cloud
Import-Module VMWare.vimautomation.core
Import-Module VMWare.vimautomation.ha
Import-Module VMWare.vimautomation.pcloud
Import-Module VMWare.vimautomation.sdk
Import-Module VMWare.vimautomation.storage
Import-Module VMWare.vimautomation.vds

# Disconnect from all vCenter servers and ESX hosts
Disconnect-VIServer * -confirm:$false

# Connect to the vCenter server specified when the script was launched
Connect-VIServer $viserver

# Query that vCenter server for all virtual machines that have a given OS name and output the list of them to a CSV file specified by $outfile
# which was entered when the script was launched
Get-VMGuest * | Where-Object {$_.OSFullName -like "*Linux*"} | Select-Object Hostname, OSFullname, IPAddress | export-csv -append $outfile

# Disconnect from all vCenter servers and ESX hosts
Disconnect-VIServer * -confirm:$false