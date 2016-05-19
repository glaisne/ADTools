$ModuleName   = "ADTools"
$ModulePath   = "C:\Program Files\WindowsPowerShell\Modules"
$TargetPath = "$($ModulePath)\$($ModuleName)"

if(-Not(Test-Path $TargetPath))
{
    mkdir $TargetPath | out-null
}

$filelist = @"
ADTools.psd1
ADTools.psm1
Convert-CanonicalNameToDistinguishedName.ps1
Get-ADTrustedDomains.ps1
Get-DomainControllers.ps1
Get-SIDHistoryDomain.ps1
Get-WindowsServers.ps1
Split-ADDNPath.ps1
Start-ADUserPoll.ps1
Test-sAMAccountNameExists.ps1
Test-UPNExists.ps1
"@

$filelist -split "`n" | % { Copy-Item -Verbose -Path "$pwd\$($_.trim())" -Destination "$($TargetPath)\$($_.trim())" }