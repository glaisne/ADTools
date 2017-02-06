function Get-TrustDirectionFriendlyName
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
        [int[]] $trustDirection
    )

    Begin
    {
    }
    Process
    {
        switch ($trustDirection)
        {
            0
            {
                'Bidirectional'
                break
            }

            1
            {
                'Inbound'
                break
            }

            2
            {
                'Outbound'
                break
            }
            Default
            {
                'Unknown'
            }
        }
    }
    End
    {
    }
}