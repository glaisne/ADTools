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
function Split-ADCanonicalName
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]] $CanonicalName,
        [switch] $leaf
    )

    foreach ($Cn in $CanonicalName)
    {
        if ($leaf)
        {
            $cn.Substring($cn.LastIndexOf('/') + 1)
        }
        else
        {
            $cn.Substring(0,$cn.LastIndexOf('/') + 1)
        }
    }
}