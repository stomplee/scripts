<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to get the Windows activation status of machines in an AD domain based on their hostnames and OU
    and then outputs the results to a CSV file.  This script requires some changes before it can be run, namely the 
    final line of it in which you need to edit the hostname and OU filters to get the results you want.
.EXAMPLE
get-adcomputer <computername> | get-activationstatus
#> 
function Get-ActivationStatus {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$DNSHostName = $Env:COMPUTERNAME
    )
    process {
        try {
            $wpa = Get-WmiObject SoftwareLicensingProduct -ComputerName $DNSHostName `
            -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" `
            -Property LicenseStatus -ErrorAction Stop
        } catch {
            $status = New-Object ComponentModel.Win32Exception ($_.Exception.ErrorCode)
            $wpa = $null    
        }
        $out = New-Object psobject -Property @{
            ComputerName = $DNSHostName;
            Status = [string]::Empty;
        }
        if ($wpa) {
            :outer foreach($item in $wpa) {
                switch ($item.LicenseStatus) {
                    0 {$out.Status = "Unlicensed"}
                    1 {$out.Status = "Licensed"; break outer}
                    2 {$out.Status = "Out-Of-Box Grace Period"; break outer}
                    3 {$out.Status = "Out-Of-Tolerance Grace Period"; break outer}
                    4 {$out.Status = "Non-Genuine Grace Period"; break outer}
                    5 {$out.Status = "Notification"; break outer}
                    6 {$out.Status = "Extended Grace"; break outer}
                    default {$out.Status = "Unknown value"}
                }
            }
        } else {$out.Status = $status.Message}
        $out
    }
}
# This part of the script queries all of AD for all computers with "lyn-" as part of their hostname
# but excludes the Linux OU and then takes that resultant list of servers, pipes the output into get-activationstatus 
# and then outputs the result to a CSV file
Get-ADComputer -filter {(name -like 'lyn*')} | where {$_.distinguishedname -notmatch 'OU=Linux,OU=Company Servers,DC=companyinternal,DC=com'} | ForEach-Object {$_.Name} | Get-ActivationStatus | export-csv -append outfile.csv
