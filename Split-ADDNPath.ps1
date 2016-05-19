function Split-ADDNPath
{
<#
.Synopsis
   Get the parrent DN or the 'Leaf' of a given distinguishedName
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $DistinguishedName,
        [switch] $leaf
    )

    Begin
    {
    }
    Process
    {
        if ($leaf)
        {
            $DistinguishedName -replace "^..\s*=\s*(.*?),.*", '$1'
        }
        else
        {
            #$DistinguishedName -replace "^(CN|OU)\s*=\s*[^,]*,", ""
            $DistinguishedName -replace "^..\s*=\s*.*?,(\s*..\s*=)", '$1'
        }
    }
    End
    {
    }
}