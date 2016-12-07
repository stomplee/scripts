<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to query Windows activation status based on an input list of servers in .TXT format
.PARAMETER inputfile
    The list of servers you wish to check activation status of in .TXT format
.PARAMETER outfile
    Path and filename of the .CSV file to export the results to
.EXAMPLE
./LicenseCheck_From_CSV.ps1 -inputfile c:\temp\serverlist.txt -outfile C:\temp\activationstatusresults.csv
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$inputfile,
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )

# Load the list of servers in $inputfile into a variable for future processing
$servernameArray = Get-Content $inputfile

# Run a loop against the list of servers provided and query Windows activation status and export the results to a file specified by $outfile
foreach ($server in $servernameArray)
    {
    Get-WmiObject SoftwareLicensingProduct -computername $server | Where-Object { $_.LicenseStatus -eq 1 } | Select-Object -Property PSComputerName,Description | export-csv -notype -append $outfile
    }