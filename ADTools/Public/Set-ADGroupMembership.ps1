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
function Set-ADGroupMembership
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $Group,

        # Param2 help description
        [string[]]
        $Add,
        [string[]]
        $Remove
    )

    Foreach ($grp in $Group)
    {
        $CurrentGroup = $null
        Try
        {
            $CurrentGroup = get-adGroup -ldapfilter "(anr=$Grp)" 
        }
        Catch
        {
            $Err = $_
            write-Warning "Error getting Group ($Grp) : $($Err.Exception.Message)"
        }
        
        if ($CurrentGroup -eq $null)
        {
        	Write-Warning "Group not found ($Grp)."
            Continue
        }
        
        if ($CurrentGroup -is [object[]])
        {
            Write-warning "Ambiguous Group. Found $(($CurrentGroup | measure).count) Groups"
            Continue
        }
        
        if ($CurrentGroup -isnot [Microsoft.ActiveDirectory.Management.ADGroup])
        {
            Write-Warning "Unknown object type ($($CurrentGroup.GetType().Name))"
            Continue
        }

        foreach ($Entry in $Add)
        {
            $user = $null
            Try
            {
                $user = get-aduser -ldapfilter "(anr=$Entry)"
            }
            Catch
            {
                $Err = $_
                write-Warning "Error getting user ($Entry) : $($Err.Exception.Message)"
                Continue
            }
            
            if ($user -eq $null)
            {
            	Write-Warning "User not found ($Entry)."
                Continue
            }
            
            if ($user -is [object[]])
            {
                Write-warning "Ambiguous user. Found $(($user | measure).count) users"
                Continue
            }
            
            if ($user -isnot [Microsoft.ActiveDirectory.Management.ADUser])
            {
                Write-Warning "Unknown user type ($($user.GetType().Name))"
                Continue
            }

            Write-Verbose "Adding $($user.UserprincipalName) to group $($CurrentGroup.distinguishedName)"
            Try
            {
                Add-ADGroupMember -Identity $CurrentGroup.distinguishedName -Members $user.DistinguishedName -ErrorAction Stop
                "Added $($user.UserprincipalName) to group $($CurrentGroup.distinguishedName)"
            }
            catch
            {
                $err = $_
                Write-Warning "Failed adding user ($($user.UserprincipalName)) to group ($($CurrentGroup.distinguishedName)) : $($err.Exception.Message)"
            }
        }

        $Entry = $null

        foreach ($Entry in $Remove)
        {
            $user = $null
            Try
            {
                $user = get-aduser -ldapfilter "(anr=$Entry)"
            }
            Catch
            {
                $Err = $_
                write-Warning "Error getting user ($Entry) : $($Err.Exception.Message)"
                Continue
            }
            
            if ($user -eq $null)
            {
            	Write-Warning "User not found ($Entry)."
                Continue
            }
            
            if ($user -is [object[]])
            {
                Write-warning "Ambiguous user. Found $(($user | measure).count) users"
                Continue
            }
            
            if ($user -isnot [Microsoft.ActiveDirectory.Management.ADUser])
            {
                Write-Warning "Unknown user type ($($user.GetType().Name))"
                Continue
            }

            Write-Verbose "Removeing $($user.UserprincipalName) from group $($CurrentGroup.distinguishedName)"
            Try
            {
                Remove-ADGroupMember -Identity $CurrentGroup.distinguishedName -Members $user.DistinguishedName -ErrorAction Stop
                "Removed $($user.UserprincipalName) from group $($CurrentGroup.distinguishedName)"
            }
            catch
            {
                $err = $_
                Write-Warning "Failed to remove user ($($user.UserprincipalName)) from group ($($CurrentGroup.distinguishedName)) : $($err.Exception.Message)"
            }
        }
    }

}