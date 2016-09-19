function Get-NearbyDCHostname
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $Domain
    )

    Begin
    {
    }
    Process
    {
        $NearestDC = (Get-ADDomainController -Discover -MinimumDirectoryServiceVersion Windows2008 -NextClosestSite -DomainName $Domain).Hostname
        if ($NearestDC.Count -gt 0)
        {
            $NearbyDCHostname = $NearestDC[0]
        }
        else
        {
            $NearbyDCHostname = $Domain
        }

        $NearbyDCHostname
    }
    End
    {
    }
}