<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to generate a report of VMWare virtual machine disk sizes in CSV format
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER inputfile
    Path and filename of the input list of servers to query the disk sizes of in .TXT format
.PARAMETER outfile
    Path and filename in .CSV format to save the results to
.EXAMPLE
./GetVMDiskSizes -viserver vCenterServer01 -inputfile C:\temp\inputlist.txt -outfile c:\temp\disksizeresults.csv
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$inputfile
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

# Disconnect from all vCenter servers and ESX hosts
Disconnect-VIServer * -Confirm:$false

# Connect to the server specified by the $viserver value entered upon script execution
Connect-Viserver $viserver

# Scan the contents of $inputfile and save them to a variable for future processing
$inputlist = Get-Content $inputfile

# Query each virtual machine in the input list and save a report of all hard drives and their capacities to the location specified by $outfile
# If this script bombs it means the ,@{n="VM";e={$_.parent.name} section below can be removed as it was a throwback to when the inputlist
# was in CSV format in an earlier version of this script.
Get-Harddisk -vm ($inputlist | select -exp name -unique) | select name,capacitygb,@{n="VM";e={$_.parent.name}} | sort vm,capacitygb | export-csv -notype $outfile

# Disconnect from all vCenter servers and ESX hosts
Disconnect-VIServer * -Confirm:$false