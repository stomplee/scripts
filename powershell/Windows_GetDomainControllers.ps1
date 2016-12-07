<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to query Active Directory and generate a list of all domain controllers in the domain it is run from
.PARAMETER outfile
    Path and filename of the resultant .txt list of domain controllers
.EXAMPLE
./GetDomainControllers.ps1 -outfile C:\temp\dclist.txt
#>
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$outfile
    ) 
$ADInfo = Get-ADDomain
$ADDomainReadOnlyReplicaDirectoryServers = $ADInfo.ReadOnlyReplicaDirectoryServers
$ADDomainReplicaDirectoryServers = $ADInfo.ReplicaDirectoryServers
$DomainControllers = $ADDomainReadOnlyReplicaDirectoryServers + ` $ADDomainReplicaDirectoryServers | out-file -append $outfile
