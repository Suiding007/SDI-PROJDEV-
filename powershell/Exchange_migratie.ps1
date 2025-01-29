Get-User -OrganizationalUnit "OU=UNI-HAR,DC=Knaak-Hosting,DC=nl" | Enable-Mailbox  

Get-User -OrganizationalUnit "OU=UNI-HAR,DC=Knaak-Hosting,DC=nl" | ForEach-Object { Set-Mailbox -Identity $_.DisplayName -EmailAddresses @{Add="smtp:$($_.DisplayName)@ijsselstreek-university.nl"} }


