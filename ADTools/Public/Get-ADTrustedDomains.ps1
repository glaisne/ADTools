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
    Param ()

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
        $ADTrustedDomains = Get-ADObject -Filter {ObjectClass -eq "TrustedDomain"} -Properties * -ErrorAction Stop
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
        switch ($($Trust.TrustType))
        {
            # Taken from http://msdn.microsoft.com/en-us/library/system.directoryservices.activedirectory.trusttype(v=vs.110).aspx
            0
            {
                Write-Verbose "This TrustType is a 'CrossLink' Trust."
                $TypeDescription = "CrossLink"
                break
            }
            1
            {
                Write-Verbose "This TrustType is a 'External' Trust."
                $TypeDescription = "External"
                break
            }
            2
            {
                Write-Verbose "This TrustType is a 'Forest' Trust."
                $TypeDescription = "Forest"
                break
            }
            3
            {
                Write-Verbose "This TrustType is a 'Kerberos' Trust."
                $TypeDescription = "Kerberos"
                break
            }
            4
            {
                Write-Verbose "This TrustType is a 'ParentChild' Trust."
                $TypeDescription = "ParentChild"
                break
            }
            5
            {
                Write-Verbose "This TrustType is a 'treeRoot' Trust."
                $TypeDescription = "treeRoot"
                break
            }
            6
            {
                Write-Verbose "This TrustType is a 'Unknown' Trust."
                $TypeDescription = "Unknown"
                break
            }
            Default
            {
                Write-Verbose "This TrustType wasn't found. Setting trust type to 'Unknown.'"
                $TypeDescription = "Unknown"
            }
        }

        Write-Verbose "Add 'TrustTypeDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustTypeDescription" -Value $TypeDescription -force


        Switch ($($Trust.TrustAttributes))
        {
            0x1 
            {
                $TrustAttributes = “Non-Transitive”
            }
            0x2
            {
                $TrustAttributes = “Uplevel clients only”
            }
            0x4
            {
                $TrustAttributes = “Quarantined Domain”
            }
            0x8
            {
                $TrustAttributes = “Forest Transitive”
            }
            0x10
            {
                $TrustAttributes = “Cross Organization”
            }
            0x20
            {
                $TrustAttributes = “Within Forest”
            }
            0x40
            {
                $TrustAttributes = “Treat As External”
            }
            0x80
            {
                $TrustAttributes = “Uses RC4 Encryption”
            }
            0x200
            {
                $TrustAttributes = “Cross Organization No TGT Delegation”
            }
            0x2
            {
                $TrustAttributes = “Uplevel clients only”
            }
            0x2
            {
                $TrustAttributes = “Uplevel clients only”
            }
            0x40000
            {
                $TrustAttributes = “Tree parent”
            }
            0x80000
            {
                $TrustAttributes = “Tree root”
            }
        }

        Write-Verbose "Add 'TrustAttributesDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustAttributesDescription" -Value $TrustAttributes -force

        switch ($($Trust.TrustDirection))
        {
            0
            {
                $TrustDirectionDescription = "Bidirectional"
            }
            1
            {
                $TrustDirectionDescription = "Inbound"
            }
            2
            {
                $TrustDirectionDescription = "Outbound"
            }
        }

        Write-Verbose "Add 'TrustDirectionDescriptionDescription' To the Trust Object."
        $Trust | Add-Member -MemberType NoteProperty -Name "TrustDirectionDescriptionDescription" -Value $TrustDirectionDescription -force


        $Trust | select * | Write-Output 
    }
}