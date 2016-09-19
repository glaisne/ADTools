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
function Test-DomainLockoutStatus
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]] $UserPrincipalName,
        [string] $Domain
    )

    Begin
    {
        if (-Not ($PSBoundParameters.ContainsKey('Domain')))
        {
            $Domain = $UserPrincipalName.Split('@')[1]
        }

        $DomainControllers = (Get-ADDomain -Identity $Domain).ReplicaDirectoryServers
    }
    Process
    {
        foreach ($upn in $UserPrincipalName)
        {
            Write-Progress -Activity "Processing $upn"

            $Object = New-Object PSObject -Property @{
                UserPrincipalName = $upn
            }

            Foreach ($DC in $DomainControllers)
            {
                Write-Progress -Activity "Checking $DC"

                $Object | Add-Member -MemberType NoteProperty -Name $DC -Value ([string]::Empty) -Force

                $user = $null
                Try
                {
                    $user = get-aduser -filter {UserPrincipalName -eq $upn } -server $DC -Properties LockedOut -ErrorAction Stop
                }
                Catch
                {
                    $Err = $_
                    write-Warning "Error getting user ($upn) on server $DC : $($Err.Exception.Message)"
                    $Object.$DC = $($Err.Exception.Message)
                    continue
                }
                
                if ($user -eq $null)
                {
                	Write-Warning "User not found ($upn) on server $DC."
                    $Object.$DC = "Not found"
                    continue
                }

                if ($user.LockedOut)
                {
                    $Object.$DC = "Locked Out"
                }
                Else
                {
                    $Object.$DC = "NOT Locked Out"
                }
            }
        }
        $Object
    }
    End
    {
    }
}