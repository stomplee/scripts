# Declare cleanup schedule variables
$initialcleanup = (Get-Date).AddDays(-10)

# Declare folder paths for Dropbox and cleanup folder
$dropboxpath = "F:\EU-DROPBOX"

# Delete files older than 10 days in $dropboxpath directory
Get-ChildItem -Path $dropboxpath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $initialcleanup } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files in the $dropboxpath directory
Get-ChildItem -Path $dropboxpath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse