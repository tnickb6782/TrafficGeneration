# Simple script to create batches of users in a domain.
# The csv file must have columns specified as "Firstname", "Lastname", "OU", "Description", and "Password" (randomly generated of course). 
$Users = Import-Csv -Path (Read-Host "Input file path of user list")            
foreach ($User in $Users)            
{            
    $Displayname = $User.Firstname + " " + $User.Lastname            
    $UserFirstname = $User.Firstname            
    $UserLastname = $User.Lastname            
    $OU = "$User.OU"            
    $SAM = $User.Firstname + "." + $User.Lastname           
    $UPN = $User.Firstname + "." + $User.Lastname + "@domain.com" #change domain as appropriate            
    $Description = $User.Description            
    $Password = $User.Password            
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM `
        -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" `
        -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false `
        –PasswordNeverExpires $true -server domain
}