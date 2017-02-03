function Test-sAMAccountNameExists
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
        [string[]]    $sAMAccountName,

        # Param2 help description
        [String]      $Server
    )

    Begin
    {
    }
    Process
    {
        foreach ($Sam in $sAMAccountName)
        {
            $SamAlreadyExists = $False
            $foundSam = $null
            try
            {
                if ([string]::IsNullOrEmpty($Server))
                {
                    $foundSam = get-aduser -filter {sAMAccountname -eq $Sam} -ErrorAction Stop
                }
                else
                {
                    $foundSam = get-aduser -filter {sAMAccountname -eq $Sam} -Server $Server -ErrorAction Stop
                }
            }
            catch
            {
                $err = $error[0]
                Write-Warning "There was issue trying to access ad user with sAMAccountname $Sam : $($err.exception.message)"
            }

            if ($FoundSam -eq $null <# this is good. #>)
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