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
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidatePattern(".*@.*\..*")]
        [string[]]    $UserPrincipalName,

        # Param2 help description
        [String]      $Server = $Null
    )

    Begin
    {
    }
    Process
    {
        foreach ($upn in $UserPrincipalName)
        {
            $UpnAlreadyExists = $False
            $foundUPN = $null
            try
            {
                if ([string]::IsNullOrEmpty($Server))
                {
                    $foundUPN = get-aduser -filter {userprincipalname -eq $upn} -ErrorAction Stop
                }
                else
                {
                    $foundUPN = get-aduser -filter {userprincipalname -eq $upn} -Server $Server -ErrorAction Stop
                }
            }
            catch
            {
                $err = $error[0]
                Write-Warning "There was issue trying to access ad user with upn $upn : $($err.exception.message)"
            }

            if ($FoundUPN -eq $null <# this is good. #>)
            {
                write-output $False
            }
            else
            {
                write-output $True
            }


        }
    }
    End
    {
    }
}
