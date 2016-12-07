<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to take an input list of virtual machines and then query them for the datastores they use and then output the results to a .CSV file
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER inputfile
    Path to the .TXT file containing a list of virtual machines you with to query the datastores of
.PARAMETER outfile
    Path and file name of the .CSV file you wish to export the results of the script to
.EXAMPLE
./VMDatastoreDiskMapping.ps1 -viserver vCenterServer01.domain.com -inputfile c:\temp\serverlist.txt -outfile c:\temp\results.csv
#> 

Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$inputfile,
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

# Disconnect from all vCenter and ESX servers
Disconnect-VIServer * -Confirm:$false 

# Connect to the server specified by $viserver
connect-viserver $viserver

# Load the contents of $inputfile into a variable for future processing
$inputlist = Get-Content $inputfile

# Loop through all the servers listed in $inputfile and query for the datastores they use and export the results to a .CSV file specified by $outfile
foreach ($computer in $inputlist)
    {
    Get-Datastore -vm $computer | Select-Object Name,CapacityGB,FreeSpaceGB -First 1 | export-csv -notype -append $outfile
    }

# Disconnect from all vCenter and ESX servers
Disconnect-VIServer * -Confirm:$false 