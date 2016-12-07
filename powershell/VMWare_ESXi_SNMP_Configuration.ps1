<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to configure ESXi host SNMP settings
.PARAMETER viserver
    The ESXi host server to connect to and run the script against.
.EXAMPLE
./SetESXSNMP.ps1 -viserver <FQDN of ESXi host>
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver
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

# Connect to the server specified by $viserver, edit the password field and replace insert_pw_here with the root ESX host password
connect-VIServer $viserver -user root -password <insert_pw_here>

# Enable SNMP on the given ESX host
Get-VMHostSNMP | Set-VMHostSNMP -Enabled:$true -confirm:$false

# Specify an SNMP community name as well as a server you wish to grant access to poll SNMP from
# I could not find a way to pass all 3 values in one line so I do the same process for each monitoring server individually
# Replace <MonitorServer1> <MonitorServer2> etc with the FQDN of the given monitoring server you wish to poll the ESX server in question with
# Replace <CommunityName> with the desired SNMP community name
Get-VMHostSNMP | Set-VMHostSNMP -AddTarGet -TargetCommunity <CommunityName> -TargetHost <MonitorServer1>
Get-VMHostSNMP | Set-VMHostSNMP -AddTarGet -TargetCommunity <CommunityName> -TargetHost <MonitorServer2>
Get-VMHostSNMP | Set-VMHostSNMP -AddTarGet -TargetCommunity <CommunityName> -TargetHost <MonitorServer3>

# Disconnect from all vCenter and ESX servers
Disconnect-VIServer * -Confirm:$false