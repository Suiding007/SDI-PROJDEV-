#####change file name######
Rename-Item C:\Windows\System32\dns\db.ijsselstreek-university.nl -NewName ijsselstreek-university.nl.dns

#####Loading dns files into Windows DNS######
dnscmd ad1-knaak /zoneadd "ijsselstreek-university.nl" /primary  /file "ijsselstreek-university.nl.dns" /load

########crate NS wins1 record#########
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl" -A -Name "wins1" -AllowUpdateAny -IPv4Address "10.8.0.10"
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl"  -AllowUpdateAny -NameServer "wins1.ijsselstreek-university.nl" -NS "ijsselstreek-university.nl" 

########crate NS wins2 record#########
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl" -A -Name "wins2" -AllowUpdateAny -IPv4Address "10.8.0.11"
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl"  -AllowUpdateAny -NameServer "wins2.ijsselstreek-university.nl" -NS "ijsselstreek-university.nl" 

