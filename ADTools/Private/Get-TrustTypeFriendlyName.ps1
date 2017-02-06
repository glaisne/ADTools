function Get-TrustTypeFriendlyName
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
        [int[]] $TrustType
    )

    Begin
    {
    }
    Process
    {
        foreach ($TT in $TrustType)
        {

            switch ($TT)
            {
                # Taken from http://msdn.microsoft.com/en-us/library/system.directoryservices.activedirectory.trusttype(v=vs.110).aspx
                0
                {
                    Write-Verbose "This TrustType is a 'CrossLink' Trust."
                    "CrossLink"
                    break
                }
                1
                {
                    Write-Verbose "This TrustType is a 'External' Trust."
                    "External"
                    break
                }
                2
                {
                    Write-Verbose "This TrustType is a 'Forest' Trust."
                    "Forest"
                    break
                }
                3
                {
                    Write-Verbose "This TrustType is a 'Kerberos' Trust."
                    "Kerberos"
                    break
                }
                4
                {
                    Write-Verbose "This TrustType is a 'ParentChild' Trust."
                    "ParentChild"
                    break
                }
                5
                {
                    Write-Verbose "This TrustType is a 'treeRoot' Trust."
                    "treeRoot"
                    break
                }
                6
                {
                    Write-Verbose "This TrustType is an 'Unknown' Trust."
                    "Unknown"
                    break
                }
                Default
                {
                    Write-Verbose "This TrustType wasn't found. Setting trust type to 'Unknown.'"
                    "Unknown"
                }
            }
        }
    }
    End
    {
    }
}