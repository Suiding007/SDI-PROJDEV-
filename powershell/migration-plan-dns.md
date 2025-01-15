# Migration plan DNS
Voor de migratie van Bind9 naar Windows wordt er op de proxmox server een Windows Server opgezet die gaat dienen als secondary DNS server.

## Bind9 zones naar Windows server
Om de Bind9 zones over te verplaatsen naar Windows, moet de Windows server 1 eerst openssh server heb geïnstalleerd om de files te kun ontvangen vanuit de Linux servers. 

```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
```

De zones worden over gekopieerd met de ingebouwde functie: **scp**. 
<br><br>
In het eerste gedeelte van de commando wordt de zonefile "db.ijsselstreek-university.nl" die vanuit Linux wordt over geplaats naar Windows, aangegeven. In de 2de gedeelte van de commando wordt de map locatie van de Windows server aangegeven. In dit geval zal de zone files gekopieerd worden naar de Windows sever 1 in de map locatie C:\Windows\System32\dns 

```
scp /etc/bind/forward/db.ijsselstreek-university.nl administrator@192.168.189.160:"C:\Windows\System32\dns"

```

## inladen nieuwe Windows Zones
Wanneer de nieuwe zonefile is overgeplaatst naar de map C:\Windows\System32\dns, moet de filenaam van de zone veranderd worden van db.ijsselstreek-university.nl naar ijsselstreek-university.nl.dns. Windows heeft de **.dns** extensie nodig om zones in te kunnen laden.
```
Rename-Item C:\Windows\System32\dns\db.ijsselstreek-university.nl -NewName ijsselstreek-university.nl.dns
```

Vervolgens kan de zones ingeladen worden. Dit wordt gedaan via de commando **dnscmd**. De zone wordt als een primary zone ingeladen onder de naam ijsselstreek-university.nl
```
dnscmd ad0-knaak /zoneadd "ijsselstreek-university.nl" /primary  /file "ijsselstreek-university.nl.dns" /load
```

Om te verzorgen dat Windows server 2, de zones ook inlaadt, is het van belang om de twee Windows servers in te voegen als nameservers (NS). Er wordt eerst voor elke windows server een A record toegevoegd
```
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl" -A -Name "wins1" -AllowUpdateAny -IPv4Address "10.8.0.10"
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl" -A -Name "wins2" -AllowUpdateAny -IPv4Address "10.8.0.11"
```
vervolgens worden de windows servers toegevoegd aan de lijst met nameservers (NS)
```
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl" -A -Name "wins2" -AllowUpdateAny -IPv4Address "10.8.0.11"
Add-DnsServerResourceRecord -ZoneName "ijsselstreek-university.nl"  -AllowUpdateAny -NameServer "wins2.ijsselstreek-university.nl" -NS "ijsselstreek-university.nl" 
```

Bij de windows server 2 moet er een secondary zone toegevoegd van ijsselstreek-university.nl De zones worden automatisch aangevuld met alle records.
```
Add-DnsServerSecondaryZone -Name "ijsselstreek-university.nl" -ZoneFile "ijsselstreek-university.dns" -MasterServers 10.8.0.10

```



