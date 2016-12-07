Param
    (
    [Parameter(Mandatory = $true)]
    [string]$outfile
    )
$servernameArray = @(get-adcomputer -filter {(name -like 'lyn*') -or (name -like 'lit*') -or (name -like 'dev*') -or (name -like 'stg*') -or (name -like 'prod*') -or (name -like 'qa*')} | where {$_.distinguishedname -notmatch 'OU=Linux,OU=Lululemon Servers,DC=lululemoninternal,DC=com'} | ForEach-Object {$_.Name})
Get-WmiObject SoftwareLicensingProduct -computername $servernameArray | Where-Object { $_.LicenseStatus -eq 1 } | Select-Object -Property PSComputerName,Description | export-csv -notype -append $outfile