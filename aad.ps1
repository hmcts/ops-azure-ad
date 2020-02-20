param (
    $UserConfigPath,
    $GroupConfigPath
)

requiredUserConfiguration = New-Object 'System.Collections.ArrayList'
$requiredUserGroups = @{}

#$currentUserConfiguration = New-Object -TypeName System.Collections.ArrayList

Write-Output "Reading desired Azure Active Directory Configuration" 
Write-Output "Processing user configuration files from $UserConfigPath"
Write-Output "Processing group configuration files from $GroupConfigPath `n"

Get-ChildItem $UserConfigPath -Filter *.json |
Foreach-Object {
    $filename = $_.Name
    Write-Output "Found config file $filename `n" 
    $fileConfig = Get-Content $_.FullName | ConvertFrom-Json

    foreach ($i in $fileConfig)
    {
        foreach ($userList in $i.users)
        {
            foreach ($user in $userList)
            {
                Write-Host "    " $user.name
                foreach ($group in $user.groups)
                {
                    Write-Host "     -" $group
                    $requiredUserGroups[$group] = $true > null
                }
                $requiredUserConfiguration.Add($user) > null
                Write-Host "    " $user.state"`n"
            }
        }
    }
}

$azureADUsers=Get-AzureADUser -All $true

# Write-Host "Discovered:" $requiredUserConfiguration
# Write-Host "Discovered:" $requiredUserGroups



