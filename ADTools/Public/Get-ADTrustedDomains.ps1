function Get-ADTrustedDomains
{
<#
.Synopsis
   Get a list of trusted domains
.DESCRIPTION
   This function gathers information about all the trusted domains for the current domain and returns it.
.EXAMPLE
   Get-ADTrustedDomains

   This example returns a list of trusted domains.
#>

    [CmdletBinding()]
    Param (
        [string] $Domain
    )

    Write-Verbose "Determining if 'Get-ADObject' CmdLet is available."
    if (-Not $(Get-Command Get-ADObject))
    {
        try
        {
            Write-Verbose "Trying to load the Active Directory Module ('ActiveDirectory')."
            Import-Module -Name "ActiveDirectory" -ErrorAction Stop
        }
        catch
        {
            Write-Verbose "Failed to load the Active Directry Module ('ActiveDirectory')."
            throw "Unable to import module 'ActiveDirectory.' This module is required."
        }
    }
    else
    {
        Write-Verbose "CmdLet 'Get-ADObject' is available."
    }

    try
    {
        Write-Verbose "Trying to get all trusted domains."
        Write-Verbose "Call: Get-ADObject -Filter {ObjectClass -eq ""TrustedDomain""} -Properties *"

        if ($PSBoundParameters.containskey('Domain'))
        {
            $ADTrustedDomains = Get-ADObject -Filter {ObjectClass -eq "TrustedDomain"} -Properties * -ErrorAction Stop -Server $Domain
        }
        else
        {
            $ADTrustedDomains = Get-ADObject -Filter {ObjectClass -eq "TrustedDomain"} -Properties * -ErrorAction Stop
        }
    }
    catch
    {
        write-error $_
        Write-Verbose "Failed to get any AD object where ObjectClass = 'TrustedDomain'."
        throw "Unable to get the list of trusted domains."
    }

    foreach ($ADTrustedDomain in $ADTrustedDomains)
    {
        $Trust = $ADTrustedDomain

        Write-Verbose "Determining the TrustType for the Trust $($ADTrustedDomain.CN)"
        $TypeDescription = Get-TrustTypeFriendlyName -TrustType $Trust.TrustType

        Write-Verbose "Add 'TrustTypeDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustTypeDescription" -Value $TypeDescription -force

        $TrustAttributes = Get-TrustAttributesFriendlyName -TrustAttributes $Trust.TrustAttributes

        Write-Verbose "Add 'TrustAttributesDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustAttributesDescription" -Value $TrustAttributes -force

        $TrustDirectionDescription = Get-trustDirectionFriendlyName -TrustDirection $Trust.TrustDirection

        Write-Verbose "Add 'TrustDirectionDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustDirectionDescription" -Value $TrustDirectionDescription -force


        $Trust | select * | Write-Output 
    }
}