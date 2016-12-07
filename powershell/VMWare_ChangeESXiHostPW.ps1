<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to change the root password on ESXi host servers based on a .txt file input list of ESX hosts.
    The values for <CUrrentPW> and <NewPW> specified on line 30-31 will need to be modified with the passwords to be
    changed.
.PARAMETER inputlist
    Location of a text file list of ESX hosts to run the script against
.EXAMPLE
./ChangeESXiHostPW.ps1 -inputlist C:\temp\vmlist.txt
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$inputlist
    ) 

# Load the VMWare modules into vanilla powershell
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

# Loop through each entry in the input list, connecting to the ESX host, changing the password then disconnecting
foreach ($server in $inputlist)
    {
    Connect-VIServer $server -user root -password <CurrentPW>
    Set-VMHostAccount -UserAccount root -Password <NewPW>
    Disconnect-VIServer * -confirm:$false
    }