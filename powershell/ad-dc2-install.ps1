$ipConfig = @{
   
    InterfaceIndex = 4
    IPAddress = "10.0.8.99"
    PrefixLength = 24
    DefaultGateway = "10.0.8.1" 
    AddressFamily = "IPv4" 

}
New-NetIPAddress @ipConfig

$addDNS = @{

    InterfaceIndex = 4
    ServerAddress = ("10.8.0.10")


} 
Set-DnsClientServerAddress @addDNS

$setup = @{
    DomainName = "knaak-hosting.nl"
    Credential = (Get-Credential "KNAAK-HOSTING\KnaakAdmin")
    SiteName = "Default-First-Site-Name"
    InstallDns = $True
    NoGlobalCatalog = $false
    CreateDnsDelegation = $false 
    CriticalReplicationOnly = $false
    DatabasePath = "C:\Windows\NTDS"
    LogPath = "C:\Windows\NTDS"
    SysvolPath = "C:\Windows\SYSVOL"
    NoRebootOnCompletion = $false 
    ReplicationSourceDC = "ad1-knaak.knaak-hosting.nl"
    Force = $true
}
Install-ADDSDomainController @setup
