function Test-UPNExists
{
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
    [CmdletBinding()]
    [OutputType([boolean])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidatePattern(".*@.*\..*")]
        [string[]]
        $UserPrincipalName,

        [String]
        $Server
    )

    Begin
    {
    }
    Process
    {
        $UpnAlreadyExists = $False
        $foundUPN = $null
        try
        {
            if ($PSBoundParameters.ContainsKey('Server'))
            {
                $foundUPN = get-aduser -filter {UserPrincipalName -eq $UserPrincipalName} -Server $Server -ErrorAction Stop
            }
            else
            {
                $foundUPN = get-aduser -filter {UserPrincipalName -eq $UserPrincipalName} -ErrorAction Stop
            }
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException]
        {
            $err = $_
            throw "Unable to reach the server specified ($server) : $($err.exception.message)"
        }
        catch
        {
            $err = $_
            Write-Warning "There was issue trying to access ad user with upn $UserPrincipalName : $($err.exception.message)"
        }

        if ($FoundUPN -eq $null)
        {
            write-output $False
        }
        else
        {
            write-output $True
        }
    }
    End
    {
    }
}
