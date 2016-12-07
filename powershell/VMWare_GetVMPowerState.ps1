<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to read from an list of servers in .txt format and then query for their power state and output the results to a .CSV file
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against
.PARAMETER inputfile
    Path and filename of the input list of server names in .TXT format
.PARAMETER outfile
    Path and filename to output the results to in .CSV format
.EXAMPLE
./GetVMPowerState.ps1 -viserver vCenterServer01.domain.com -inputfile C:\temp\inputlist.txt -outfile c:\temp\powerstateresults.csv
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

# Disconnect from all vCenter and ESX hosts
Disconnect-VIServer * -Confirm:$false

# Connect to the server specifed by $viserver when the script was first launched
Connect-viserver $viserver

# Load the contents of $inputfile into a variable for future processing
$inputlist = Get-Content $inputfile

# Run a loop against each server in $inputlist that grabs the hostname and powerstate of the server and exports the results to a 
# .CSV file specified by $outfile
foreach ($computer in $inputlist)
    {
    Get-vm $computer | select Name,Powerstate | export-csv -append $outfile
    }

# Disconnect from the server specified by $viserver
Disconnect-VIServer $viserver
