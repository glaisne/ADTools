function Get-DomainControllers
{
<#
.Synopsis
   Returns the domain controllers in the specified domain.
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $Domain,

        [PSCredential] $Credential
    )

    Begin
    {
        if (-Not $(Get-Module activedirectory))
        {
            If (get-module activeDirectory -ListAvailable)
            {
                try
                {
                    import-module activeDirectory -ErrorAction stop
                }
                catch
                {
                    throw "Unable to load the active directory module."
                }
            }
            Else
            {
                throw "The active directory module is not available on this system."
            }
        }
    }
    Process
    {
        if ($Credential)
        {
            try
            {
                $ADDomain = Get-ADDomain -Identity $Domain -Credential $Credential -ErrorAction Stop
            }
            catch
            {
                Write-error $_
            }
        }
        else
        {
            try
            {
                $ADDomain = Get-ADDomain -Identity $Domain -ErrorAction Stop
            }
            catch
            {
                Write-error $_
            }
        }
        Write-Output $($ADDomain.ReplicaDirectoryServers)
    }
    End
    { }
}