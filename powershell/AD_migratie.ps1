$set_status_1 = "SCRIPT_RAN = 1"
$ad_info = Get-ADDomain

write-host "KnaakSoft DIRTI [DIRect Terminal Importing] version 1.0.4

Copyright (C) KnaakSoft VOF.
On computer: $env:computername

Directory info:
$ad_info

This better be good...
"

$expected_security_groups = @("CN=SEC-HAR-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-HAR-ETH,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-HAR-FAC,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-HAR-MGT,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-HAR-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-HAR-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-NUN-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-NUN-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-NUN-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-PUT-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-PUT-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-PUT-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-ETH,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-FAC,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-MGT,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-DEV-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-ERM-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-ERM-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-ERM-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-EPE-BES,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-EPE-PER,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl", `
"CN=SEC-EPE-STU,OU=SEC-UNI-GROUPS,DC=Knaak-Hosting,DC=nl" 
)
# Array of security groups that *should be* in the Directory 

$amount_of_sec_groups = 0

write-host "Checking if all object required for import are actually there"
write-host "Checking Security Groups"
$securtiy_groups_in_ad = Get-ADObject -LDAPFilter "(&(objectClass=group)(name=sec-*))"
foreach ($security_group in $securtiy_groups_in_ad) {
    if ($security_group -notin $expected_security_groups) {
        Write-Host "Object: $security_group not found in directory"
        }
    else {
        $amount_of_sec_groups++
    }
}
if ( $amount_of_sec_groups -lt 24 ) {
    Write-Warning "Expected 24 groups, found $amount_of_sec_groups"
} else {
Write-host "All groups found in Directory"
}

Write-Host "Checking if student security objects exist in Directory"
if (    (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-har-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null -or `
        (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-nun-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null -or `
        (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-put-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null -or `
        (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-erm-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null -or `
        (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-epe-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null -or `
        (Get-ADObject -filter "DistinguishedName -eq 'CN=sec-dev-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl'") -eq $null `
    )    {
    Write-Warning "Some or All security objects were not found in the Active Directory"
    }
else {
write-host "Prerequisit tests completed successfully."
}
    
Pause

write-host "Updating LDIF file..."
(Get-Content C:\Users\knaakadmin\Desktop\ldif.ldif).Replace('uid=', 'cn=') | Set-Content -Path "C:\Users\knaakadmin\Desktop\fixed.ldif"

If (((Get-Content -Path C:\Users\knaakadmin\Desktop\importstatus.txt)[0] -eq "SCRIPT_RAN = 1") `
-and (Get-FileHash -Path "C:\Users\knaakadmin\Desktop\fixed.ldif") -eq (Get-Content -Path C:\Users\knaakadmin\Desktop\importstatus.txt)[1]){
    Write-warning "Objects already exist in directory, you can force a re-import but it might break something!"
    $im_stupid = Read-Host "Type 'force' to force import"
}

elseif (((Get-Content -Path C:\Users\knaakadmin\Desktop\importstatus.txt)[0] -eq "SCRIPT_RAN = 1") `
-and (Get-FileHash -Path "C:\Users\knaakadmin\Desktop\fixed.ldif" | Select-Object Hash) -ne (Get-Content -Path C:\Users\knaakadmin\Desktop\importstatus.txt)[1]) {
    Write-Warning "This LDIF has been (partly) imported, but the content has changed!, you can force a re-import but it might break something!"
    $im_stupid = Read-Host "Type 'force' to force import"
}

if (((Get-Content -Path C:\Users\knaakadmin\Desktop\importstatus.txt) -ne $set_status_1) -or ($im_stupid -eq "force")) {
    Write-Host "Starting import..."

# ^^ Testing if the hash of te previous import matches the one we are trying to import now

write-host "Trying to import structure into directory..."
ldifde -i -f C:\Users\knaakadmin\desktop\fixed.ldif -c dc=radius,dc=ijsselstreek-university,dc=nl dc=knaak-hosting,dc=nl -k -v
# Invokes the LDIFDE command to start the import
# The -c flag changes the domain to the correct domain
# The -k flag continues when an error occures or not all data fields can be populated
# The -v flag enables verbose mode so we can check the output

pause

write-host "Enabling Users..."
Get-ADUser -filter * -searchbase "ou=people,dc=knaak-hosting,dc=nl" | % {Set-ADUser $_ -enabled $true}
# Grab all users that we imported and enable the accounts

pause

Write-Host "Updating UserPrincipalNames..."
Get-ADUser -filter * -searchbase "ou=people,dc=knaak-hosting,dc=nl" | % {Set-ADUser $_ -UserPrincipalName ($_.Surname + "@knaak-hosting.nl")}
# Change the UPN based on the surname, Linux didn't use that field so it's empty making logging in pretty much impossible .

pause

Write-Host "Moving users into the right OU, based(c) on name..."
Write-Host "Assigning Security Groups..." 

$HAR_STU_users = (Get-ADUser -filter 'UserPrincipalName -like "Stud*"')[0..8]
    foreach ($object in $HAR_STU_users) {
        Move-ADObject -Targetpath 'ou=har-stu,ou=HAR,ou=UNI-HAR,dc=knaak-hosting,dc=nl' -Identity $object.DistinguishedName
        Add-ADGroupMember -Identity "CN=sec-har-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl" -Members $object
        }
$NUN_STU_users = (Get-ADUser -filter 'UserPrincipalName -like "Stud*"')[9..18]
    foreach ($object in $NUN_STU_users) {
        Move-ADObject -Targetpath 'ou=nun-stu,ou=NUN,ou=UNI-HAR,dc=knaak-hosting,dc=nl' -Identity $object.DistinguishedName
        Add-ADGroupMember -Identity "CN=sec-nun-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl" -Members $object
        }
$DEV_STU_users = (Get-ADUser -filter 'UserPrincipalName -like "Stud*"')[19..25] 
    foreach ($object in $DEV_STU_users) {
        Move-ADObject -Targetpath 'ou=dev-stu,ou=DEV,ou=UNI-HAR,dc=knaak-hosting,dc=nl' -Identity $object.DistinguishedName
        Add-ADGroupMember -Identity "CN=sec-har-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl" -Members $object
        }
$ERM_STU_users = (Get-ADUser -filter 'UserPrincipalName -like "Stud*"')[26..40] 
    foreach ($object in $ERM_STU_users) {
        Move-ADObject -Targetpath 'ou=erm-stu,ou=ERM,ou=UNI-HAR,dc=knaak-hosting,dc=nl' -Identity $object.DistinguishedName
        Add-ADGroupMember -Identity "CN=sec-ERM-stu,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl" -Members $object
        }

$DEV_PER_users = (Get-ADUser -filter 'UserPrincipalName -like "Staf*"')
    foreach ($object in $DEV_PER_users) {
        Move-ADObject -Targetpath 'ou=erm-per,ou=ERM,ou=UNI-HAR,dc=knaak-hosting,dc=nl' -Identity $object.DistinguishedName
        Add-ADGroupMember -Identity "CN=sec-ERM-PER,OU=SEC-UNI-GROUPS,DC=knaak-hosting,DC=nl" -Members $object
        }

pause

#Move the accounts to the Right OU based on array index (users were all in one group) and add them to te proper security object.

$objects_in_people = (Get-ADObject -Filter * -SearchScope OneLevel -searchbase "ou=people,dc=knaak-hosting,dc=nl" | Measure-Object).Count
$thanos_snap = Read-Host "There are $objects_in_people left in ou=people,dc=knaak-hosting,dc=nl
Type 'snap' to reduce to atoms"


if ( $thanos_snap -eq "snap" ) {
    Remove-ADObject -Identity "OU=people,DC=knaak-hosting,dc=nl" -Recursive -Confirm
    write-host -ForegroundColor DarkMagenta "Gone, reduced to atoms.."
}

else {
    write-host -ForegroundColor DarkMagenta "'What did it cost?' 'Everything'"   
}

write-host -ForegroundColor Green "Import success!"

$set_status_1 | Out-File -FilePath C:\Users\knaakadmin\Desktop\importstatus.txt
Get-FileHash -Path "C:\Users\knaakadmin\Desktop\fixed.ldif" | Select-Object Hash | Add-Content -Path "C:\Users\knaakadmin\Desktop\importstatus.txt"
    }

else {
    Write-Warning "Bailing out, good luck!"
}
