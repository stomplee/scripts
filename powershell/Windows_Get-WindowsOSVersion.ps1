<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to query WMI and determine which version of Windows the provided list of servers is running and outputs
    the results to a CSV file
.PARAMETER inputfile
    The list of servers in .TXT format run the script against.
.PARAMETER outfile
    Path and filename of the .CSV file to export the results of the query to
.EXAMPLE
./GetWindowsOSVersion.ps1 -inputfile c:\temp\serverlist.txt -outfile C:\temp\osversionresults.csv
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$inputfile,
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )

# Store the list of computer names into a variable for future processing
$inputlist = Get-Content $inputfile

# Run a loop against the input list which queries WMI and grabs the hostname and OS type of each server in the list and exports the results
# to a CSV file specified by $outfile which was enetered when the script was first launched.
foreach ($computer in $inputlist)
    {
    Get-WmiObject -class Win32_OperatingSystem -computername $computer | select-object PSComputername, Caption | export-csv -NoTypeInformation -append $outfile
    }
