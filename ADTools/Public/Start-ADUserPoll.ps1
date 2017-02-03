function Start-ADUserPoll
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
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]] $userPrincipalName,
        
        [Parameter(Mandatory=$true,
                   Position=1)]
        [string[]] $ADProperties,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [string[]] $ComputerName,

        [int32]    $PollInterval = 30,  #in seconds
        [int32]    $PollCount    = 100
    )

    Begin
    {
        $RunCount = 0
        $InitailValues = @{}
    }
    Process
    {
        foreach ($UPN in $userPrincipalName)
        {
            if ($RunCount -eq 0)
            {
                Write-verbose "Populating initial Values"
                foreach ($Computer in $ComputerName)
                {
                    $Found = $null
                    $Found = new-object psobject

                    foreach ($property in $ADProperties)
                    {
                        $Found | Add-Member -MemberType NoteProperty -Name $property -Value ([String]::Empty)
                    }

                    $User = $null
                    try
                    {
                        $user = Get-ADUser -filter {userPrincipalName -eq $UPN} -Properties $ADProperties -Server $Computer -ErrorAction Stop -ErrorVariable EV
                    }
                    catch
                    {
                        Write-Warning "There was an error accessing $UPN on $computer : $($_.Exception.Message)"
                    }

                    if ($user -eq $null)
                    {
                        foreach ($property in $ADProperties)
                        {
                            $Found.$Property = [string]::Empty
                        }
                        Continue
                    }
                    else
                    {
                        foreach ($property in $ADProperties)
                        {
                            $Found.$Property = $user.$Property.ToString()
                        }
                    }

                }
            }
            else
            {
            }

            $Runcount++
            Start-sleep -Seconds $PollInterval
        }
    }
    End
    {
    }
}