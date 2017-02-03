function Get-SIDHistoryDomain
{
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    [OutputType([string[]])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        $SidHistory,

        [Parameter(Position=1)]
        [string] $Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
    )

    Begin
    {

        $UNKNOWN = 'UNKNOWN'

#        if ($PSBoundParameters.ContainsKey('Domain'))
#        {
            $TrustedDomains = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Properties cn,securityidentifier -server $Domain
#        }
#        else
#        {
#            $TrustedDomains = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Properties cn,securityidentifier
#        }

    }
    Process
    {
        if ($SidHistory -eq $null)
        {
            Return
        }

        if ($sidHistory -is [array] -and $SidHistory.count -eq 0)
        {
            Return
        }

        $SidHistoryDomains = new-object System.Collections.ArrayList

        foreach ($sid in $SidHistory)
        {
            $Object = New-Object PSObject -Property @{
                SID    = $Sid
                Domain = $UNKNOWN
            }

            if ($sid -is [System.Security.Principal.SecurityIdentifier])
            {
                foreach ($TrustedDomain in $TrustedDomains)
                {
                    if ($sid.AccountDomainSid.Value -eq $TrustedDomain.securityidentifier.accountdomainsid.value)
                    {
                        $Object.Domain = $TrustedDomain.CN
                        Break
                    }
                }
            }
            else
            {
                $sid = $sid.ToString()

                foreach ($TrustedDomain in $TrustedDomains)
                {
                    if ($sid -match "$($TrustedDomain.securityidentifier.accountdomainsid.value)-\d+$")
                    {
                        $Object.Domain = $TrustedDomain.CN
                        Break
                    }
                }
            }

            $SidHistoryDomains.Add($Object) | Out-Null
        }

        Write-Output $SidHistoryDomains
    }
    End
    {
    }
}