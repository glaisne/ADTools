<#
.Synopsis
   Gets the name of the domain from a distinguishedname property
.DESCRIPTION
   Gets the name of the domain from a distinguishedname property
.EXAMPLE
   get-DomainNameFromDistinguishedNAme $(get-aduser gene.laisne).distinguishedName
.EXAMPLE
   Another example of how to use this cmdlet
#>
function get-DomainNameFromDistinguishedName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $DistinguishedName
    )

    Foreach ($Dn in $DistinguishedName)
    {
        ($Dn.split(',') | ? {$_ -match "DC="}).replace('DC=','') -join '.'
    }
}