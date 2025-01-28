# Python script om LDIF entries te genereren om de OpenLDAP server te populeren.
import os

# Configuratie
base_dn = "ou=peope,dc=radius,dc=ijsselstreek-university,dc=nl"
output_file = "bulk_accounts.ldif"

# LDIF-generatie
with open(output_file, "w") as ldif:
    for i in range(1, 41):
        username = f"student{i}"
        dn = f"uid={username},{base_dn}"
        ldif.write(f"""
dn: {dn}
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: {username}
sn: {username}
uid: {username}
uidNumber: {1000 + i}
gidNumber: {1000}
homeDirectory: /home/{username}
userPassword: Welkom123
loginShell: /bin/bash

""")

print(f"LDIF-bestand '{output_file}' succesvol gegenereerd.")
