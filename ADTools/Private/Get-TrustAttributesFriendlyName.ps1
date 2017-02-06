function Get-TrustAttributesFriendlyName
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [int[]] $TrustAttributes
    )

    Begin
    {
    }
    Process
    {
        foreach ($TrustAttribute in $TrustAttributes)
        {
            Switch ($TrustAttribute)
            {
                0x1 
                {
                    “Non-Transitive”
                    break
                }
                0x2
                {
                    “Uplevel clients only”
                    break
                }
                0x4
                {
                    “Quarantined Domain”
                    break
                }
                0x8
                {
                    “Forest Transitive”
                    break
                }
                0x10
                {
                    “Cross Organization”
                    break
                }
                0x20
                {
                    “Within Forest”
                    break
                }
                0x40
                {
                    “Treat As External”
                    break
                }
                0x80
                {
                    “Uses RC4 Encryption”
                    break
                }
                0x200
                {
                    “Cross Organization No TGT Delegation”
                    break
                }
                0x2
                {
                    “Uplevel clients only”
                    break
                }
                0x2
                {
                    “Uplevel clients only”
                    break
                }
                0x40000
                {
                    “Tree parent”
                    break
                }
                0x80000
                {
                    “Tree root”
                    break
                }
                Default
                {
                    'Unknown'
                }
            }
        }
    }
    End
    {
    }
}