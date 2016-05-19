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

        if ($PSBoundParameters.ContainsKey('Domain'))
        {
            $TrustedDomains = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Properties cn,securityidentifier -server $Domain
        }
        else
        {
            $TrustedDomains = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Properties cn,securityidentifier
        }

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

        $SidHistoryDomains = @()

        foreach ($sid in $SidHistory)
        {
            $SidHistoryDomain = [string]::Empty

            if ($sid -is [System.Security.Principal.SecurityIdentifier])
            {
                foreach ($TrustedDomain in $TrustedDomains)
                {
                    if ($sid.AccountDomainSid.Value -eq $TrustedDomain.securityidentifier.accountdomainsid.value)
                    {
                        $SidHistoryDomain = $TrustedDomain.CN
                        Break
                    }
                }

                if ([string]::IsNullOrEmpty($SidHistoryDomain))
                {
                    $SidHistoryDomain = $UNKNOWN
                }
            }
            else
            {
                $sid = $sid.ToString()

                foreach ($TrustedDomain in $TrustedDomains)
                {
                    if ($sid -like "$($TrustedDomain.securityidentifier.accountdomainsid.value)-*")
                    {
                        $SidHistoryDomain = $TrustedDomain.CN
                        Break
                    }
                }

                if ([string]::IsNullOrEmpty($SidHistoryDomain))
                {
                    $SidHistoryDomain = $UNKNOWN
                }
            }

            $SidHistoryDomains += $SidHistoryDomain
        }

        Write-Output $SidHistoryDomains
    }
    End
    {
    }
}