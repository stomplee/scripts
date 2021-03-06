<# PARAMETER BLOCK 
.DESCRIPTION
    This script is used to create VMWare virtual machines based on values read from a CSV file.
.PARAMETER viserver
    The VMWare vCenter server to connect to and run the script against.
.PARAMETER csvfile
    Path to CSV file that contains information such as virtual machine name, cluster, datastore etc.
    The file is expected to contain the following column headers: 
    Name OS Template Location Cluster Datastore VLAN IPAddress SubnetMask DefaultGateway DNS1 DNS2 MemoryGB NumCPU Disk1 Disk2 Disk3 Disk4 Disk5
.EXAMPLE
./CreateVM.ps1 -viserver vCenterServer01.domain.com -csvfile C:\temp\vmlist.csv
#> 
Param
    (
    [Parameter(Mandatory = $true)]
    [string]$viserver,
    [Parameter(Mandatory = $true)]
    [string]$csvfile
    )
<# Import Modules

This section imports all the required VMWare modules so you can run the later commands from a vanilla powershell session without needing to run the script under PowerCLI

#> 
Import-Module VMWare.vimautomation.cis.core
Import-Module VMWare.vimautomation.cloud
Import-Module VMWare.vimautomation.core
Import-Module VMWare.vimautomation.ha
Import-Module VMWare.vimautomation.pcloud
Import-Module VMWare.vimautomation.sdk
Import-Module VMWare.vimautomation.storage
Import-Module VMWare.vimautomation.vds
<# Disconnect vCenter 

This section disconnects from all VMWare vCenter servers so that you don't inadvertently try to create the virtual machine(s) in the wrong environment.

#>
Disconnect-VIServer * -Confirm:$false 
 <# Connect vCenter 
 
 This section will connect to the VMWare vCenter server specified by -viserver when the script is first run and exit with an error if the specified vCenter server cannot be contacted.

 #> 
$connectviserver = Connect-VIServer $viserver
If ($connectviserver.IsConnected -ne $true)
    {
    $vcenternoconnecterror = Write-Host "Error: Cannot connect to vCenter server $viserver, is the servername spelled correctly and is the server online?"
    exit $vcenternoconnecterror
    }
<# CSV File Path Verification and Importing 

This section first checks to make sure the CSV file specified by -csvfile when the script is first run is located in the specified location and is readable and if not it will error out.
If the specified CSV file is found and readable this code will then import the values in the CSV file and save them to $CSV for later processing.

#>
If (Test-Path -PathType Leaf $csvfile)
    {
    $CSV = Import-CSV -Path $csvfile
    }
    else
        {
        $csverror = Write-Host "Error: No CSV found at the specified location ($csvfile) or the CSV file is unreadable.  Do you have the correct permissions to read the file and have you specified the correct file path?"
        exit $csverror
        }
<# CSV File Validation 

This section cycles through the CSV file specified by -csvfile when the script is first run and checks the values within it to make sure the virtual machines to be created don't
already exist and that the values for cluster, datastore etc are all valid entries and exits with an appropriate error if any inaccurate information is found.

#>  
Foreach ($Row in $CSV)
    {
    $vmname = $Row.Name
    $vmnamevalidation = Get-VM -Name $vmname
    $template = $Row.Template
    $templatevalidation = Get-Template -Name $template
    $location = $Row.Location
    $checklocation = Get-Folder -Name $location
    $cluster = $Row.Cluster
    $clustervalidation = Get-Cluster -Name $cluster
    $datastore = $Row.Datastore
    $datastorevalidate = Get-Datastore -Name $datastore
    $vlan = $Row.VLAN
    $vlanvalidate = Get-VDPortgroup -server $viserver | Where-Object {$_.Name -like "*$vlan*"}
    If ($vmnamevalidation)
        {
        $vmexistserror = Write-Host "Error: The virtual machine $vmname already exists.  Please rename or remove VM from the specified CSV file ($csvfile) before trying again."
        exit $vmexistserror
        }
    If (!$templatevalidation)
       {
       $templatenotexisterror = Write-Host "Error: The specified template, ($template) cannot be found.  Was it spelled correctly and is hosted by the specified vCenter server($viserver)?"
       exit $templatenotexisterror
       }        
    If (!$checklocation)
        {
        $foldernotexisterror = Write-Host "Error: The specified location/folder ($location) cannot be found.  Was it spelled correctly?"
        exit $foldernotexisterror
        }
    If (!$clustervalidation)
        {
        $clusternotexisterror = Write-Host "Error: The specified cluster ($cluster) cannot be found.  Was it spelled correctly?"
        exit $clusternotexisterror
        }
    If (!$datastorevalidate)
        {
        $datastorenotexisterror = Write-Host "Error: The specified datastore ($datastore) cannot be found.  Was it spelled correctly?"
        exit $datastorenotexisterror
        }
    If(!$vlanvalidate)
        {
        $vlannotexisterror = Write-Host "Error:  The specified VLAN ($vlan) cannot be found.  Was the VLAN ID entered correctly?"
        exit $vlannotexisterror
        }
    }
<# Configure and provision required virtual machine(s)

This section takes the input values from the CSV file parsed earlier in the script and then creates and configures a virtual machine based on those input values.

Due to the way VMWare implemented their cmdlets you can only configure the network interfaces via OSCustomizationSpecs and those are only used when the virtual machine
is first created.

So at a high level you need to first create a temporary OSCustomizationSpec and then you need to apply an OSCustomizationSpecNicMapping to it to configure the IP Address, Subnet Mask, etc.
Once those specs are created you then create a new virtal machine based on those specs and then remove the customization specs after the process is done.

The check for Windows vs Linux is required due to a VMWare limitation of not being able to pass DNS entries to a Linux virtual machine (it can pass those values to Windows just fine).

#> 
Foreach ($vm in $CSV)
        {
        $vmname = $vm.Name
        $IPAddress = $vm.IPAddress
        $SubnetMask = $vm.SubnetMask
        $DefaultGateway = $vm.DefaultGateway
        $DNS1 = $vm.DNS1
        $DNS2 = $vm.DNS2
        $tempcustomization = "$VMName" +"_tmp_" + ( get-date -UFormat %Y%m%d.%s )
        $operatingsystem = $vm.OS
        $template = $vm.Template
        $location = Get-Folder $vm.Location
        $cluster = $vm.Cluster
        $datastore = $vm.Datastore
        $vlan = $vm.VLAN
        $notes = $vm.Notes
        If ($operatingsystem -eq "Windows")
            {
            Get-OSCustomizationSpec -server $viserver -Name DeployVMWindowsOSSpec | New-OSCustomizationSpec -server $viserver -Name $tempcustomization -Type Persistent
            Get-OSCustomizationSpec -Server $viserver -Name $tempcustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $IPAddress -SubnetMask $SubnetMask -DefaultGateway $DefaultGateway -Dns $DNS1,$DNS2
            New-VM -Template $template -Name $vmname -Location $location -ResourcePool $cluster -Datastore $datastore -Notes $notes -OSCustomizationSpec $tempcustomization
            Remove-OSCustomizationSpec $tempcustomization -Confirm:$false
            }
        Else 
            {
            If ($operatingsystem -eq "Linux")
                {
                Get-OSCustomizationSpec -server $viserver -Name DeployVMLinuxOSSpec | New-OSCustomizationSpec -server $viserver -Name $tempcustomization -Type Persistent
                Get-OSCustomizationSpec -Server $viserver -Name $tempcustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $IPAddress -SubnetMask $SubnetMask -DefaultGateway $DefaultGateway
                New-VM -Template $template -Name $vmname -Location $location -ResourcePool $cluster -Datastore $datastore -Notes $notes -OSCustomizationSpec $tempcustomization
                Remove-OSCustomizationSpec $tempcustomization -Confirm:$false
                }
            }
        }
<# Additional VM Configurations 

This section configures the newly created virtual machine(s) to use the specified number of vCPUs and RAM as well as provisioning any additional hard drives specified in the CSV file and assigning
the network adapter to the specified VLAN.

#>
Foreach ($vm in $CSV)
    {
    $vmname = $vm.Name
    $memoryGB = $vm.MemoryGB
    $numCPU = $vm.numCPU
    $vlanid = $vm.VLAN
    $diskGBs = $vm.Disk1, $vm.Disk2, $vm.Disk3, $vm.Disk4, $vm.Disk5, $vm.Disk6
    $diskGBs = $diskGBs | ForEach { $_.Trim() } | Where { $_ }
    $VLAN = Get-VDPortgroup -server $viserver | Where-Object {$_.Name -like "*$vlanid*"}
    $networkadapter = Get-VM $vmname | Get-NetworkAdapter -Name "Network adapter 1"
    Set-NetworkAdapter -NetworkAdapter $networkadapter -NetworkName $VLAN -StartConnected:$true -Confirm:$false
    Set-VM $vmname -NumCpu $numCPU -MemoryGB $memoryGB -Confirm:$false
    foreach ($diskGB in $diskGBs) 
        {
        New-HardDisk -vm $vmname -CapacityGB $diskGB -StorageFormat Thin 
        }   
    }

