###### export on server 1 ######
Export-NpsConfiguration –Path c:\config.xml

###### import on server 2 ######
Import-NpsConfiguration -Path "c:\config.xml"
