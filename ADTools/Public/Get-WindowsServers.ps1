function Get-WindowsServers
{
<#
.Synopsis
   Get all the computer in AD with both "Windows" and "Server" in the operating system.
.DESCRIPTION
   This cmdlet uses Get-ADComputer and filters on OperatingSystem for "Windows" and "Server."
.EXAMPLE
   Example of how to use this cmdlet
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]] $Domain = $([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name),
        [string[]] $Properties
    )

    Begin
    {
    }
    Process
    {
        if ([string]::IsNullOrEmpty($Properties))
        {
            $Properties = "*"
        }

        Write-verbose "Properties = $Properties"

        Foreach ($dom in $Domain)
        {
            Write-verbose "Searching for Windows Servers in the $dom Domain."
            Try
            {
                get-adcomputer -filter {operatingsystem -like "*Windows*" -and operatingsystem -like "*Server*" } -server $dom -ErrorAction Stop
            }
            catch
            {
                $err = $_
                Write-Warning "Failed getting Windows Servers for domain $dom : $($err.Exception.Message)"
            }
        }
    }
    End
    {
    }
}