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
function Get-PasswordSettingsObject
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ParameterSetName = "Named")]
        [string[]] $Name
    )

    foreach ($N in $Name)
    {
        
    }
    
}