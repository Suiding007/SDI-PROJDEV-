$setup = @{
    DomainName = "knaak-hosting.nl"
    Credential = (Get-Credential "KNAAK-HOSTING\Administrator")
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
