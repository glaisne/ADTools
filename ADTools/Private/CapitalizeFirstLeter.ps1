function CapitalizeFirstLeter
{
<#
.DESCRIPTION
   This function capitalizes the first letter of the word (or group of words) 
   and sets all other characters to lower case.
.EXAMPLE
CapitalizeFirstLeter -Word "troubadour"

In this example, "Troubadour" would be returned.
.EXAMPLE
CapitalizeFirstLeter -Word "i Like cheese"

Note: The 'i' is lower case and the 'L' in 'Like' is upper case.)

In this example, "I like cheese" would be returned.
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        [ValidatePattern("[a-z].*")]
        [String] $Word
    )
    "$($word[0].ToString().ToUpper())$($Word.Substring(1).ToLower())"
}
