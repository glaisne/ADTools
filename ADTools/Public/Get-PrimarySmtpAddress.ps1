Function Get-PrimarySmtpAddress
{
	<#
		.SYNOPSIS
		the primary SMTP address of an object.

		.DESCRIPTION
		the primary SMTP address of an object.

		.PARAMETER ProxyAddresses
		the proxyAddresses attribute to parse in order to determine
		primary SMTP address.

		.EXAMPLE
		> GetPrimarySmtpAddress -ProxyAddresses $ProxyAddresses

		.INPUTS
		.String[]

		.OUTPUTS
		.String

		.NOTES

	#>

	param
	(
		[Parameter(Mandatory = $True,
                   ParameterSetName = 'ProxyAddresses',
                   Position=0)]
        [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]
		$ProxyAddresses,
        
		[Parameter(Mandatory = $True,
                   ParameterSetName = 'ADUser',
                   Position=0)]
        [Microsoft.ActiveDirectory.Management.ADUser]
		$ADUser,
        
		[Parameter(Mandatory = $True,
                   ParameterSetName = 'ADGroup',
                   Position=0)]
        [Microsoft.ActiveDirectory.Management.ADGroup]
		$ADGroup
	)

    if ($PSCmdlet.ParameterSetName -eq 'ADUser')
    {
        if ($ADUser.proxyAddresses -is [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection] -and `
            $ADUser.proxyAddresses.Count -gt 0)
        {
            $ProxyAddresses = $ADUser.proxyAddresses
        }
        else
        {
            [System.Exception.ArgumentException]::new('Invalid or no proxyAddresses on user.')
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'ADGroup')
    {
        if ($ADGroup.proxyAddresses -is [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection] -and `
            $ADGroup.proxyAddresses.Count -gt 0)
        {
            $ProxyAddresses = $ADGroup.proxyAddresses
        }
        else
        {
            [System.Exception.ArgumentException]::new('Invalid or no proxyAddresses on user.')
        }
    }

    GetPrimarySmtpAddressFromProxyAddresses -ProxyAddresses $ProxyAddresses
}

