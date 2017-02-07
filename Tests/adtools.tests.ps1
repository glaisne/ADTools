#Import-Module $PSScriptRoot\..\ADTools -Force

Get-ChildItem -Path $PSScriptRoot\..\ADTools\Private\*.ps1 | foreach {. $($_.fullname)}

import-module "$PSScriptRoot\..\ADTools" -Force


Describe 'Private functions' {

    Context 'CapitalizeFirstLetter' {
        it 'simple test' {
            CapitalizeFirstLeter -Word 'test' | should Be 'Test'
        }
        
        it 'simple test' {
            CapitalizeFirstLeter -Word 't' | should Be 'T'
        }
        
        it 'start with all caps' {
            CapitalizeFirstLeter -Word 'TEST' | should Be 'TEST'
        }
        
        it 'start with reverse' {
            CapitalizeFirstLeter -Word 'tEST' | should Be 'TEST'
        }

        #it 'Numbers are not letters' {
        #    CapitalizeFirstLeter -Word 5 | should throw
        #}
    }

    Context 'Get-TrustAttributesFriendlyName' {

        it 'should convert int to hex' {
            Get-TrustAttributesFriendlyName -TrustAttributes 1 | should be “Non-Transitive”
        }

        it 'should take hex from string' {
            Get-TrustAttributesFriendlyName -TrustAttributes '0x1' | should be “Non-Transitive”
        }

        it 'should take hex' {
            Get-TrustAttributesFriendlyName -TrustAttributes 0x1 | should be “Non-Transitive”
        }

        it 'Invalid value (7234) = "unknown"' {
            Get-TrustAttributesFriendlyName -TrustAttributes 7234 | should be 'UNKNOWN'
        }

        it 'Invalid value (15) = "unknown"' {
            Get-TrustAttributesFriendlyName -TrustAttributes 15 | should be 'UNKNOWN'
        }
    }

    Context 'Get-TrustDirectionFriendlyName' {

        it 'should convert int to hex' {
            Get-TrustDirectionFriendlyName -TrustDirection 1 | should be “Inbound”
        }

        it 'should take hex from string' {
            Get-TrustDirectionFriendlyName -TrustDirection '0x1' | should be “Inbound”
        }

        it 'should take hex' {
            Get-TrustDirectionFriendlyName -TrustDirection 0x1 | should be “Inbound”
        }

        it 'Invalid value (7234) = "unknown"' {
            Get-TrustDirectionFriendlyName -TrustDirection 7234 | should be 'UNKNOWN'
        }

        it 'Invalid value (15) = "unknown"' {
            Get-TrustDirectionFriendlyName -TrustDirection 15 | should be 'UNKNOWN'
        }
    }

    Context 'Get-TrustTypeFriendlyName' {

        it 'should convert int to hex' {
            Get-TrustTypeFriendlyName -TrustType 1 | should be “External”
        }

        it 'should take hex from string' {
            Get-TrustTypeFriendlyName -TrustType '0x1' | should be “External”
        }

        it 'should take hex' {
            Get-TrustTypeFriendlyName -TrustType 0x1 | should be “External”
        }

        it 'Invalid value (7234) = "unknown"' {
            Get-TrustTypeFriendlyName -TrustType 7234 | should be 'UNKNOWN'
        }

        it 'Invalid value (15) = "unknown"' {
            Get-TrustTypeFriendlyName -TrustType 15 | should be 'UNKNOWN'
        }
    }
}

Describe 'Test-UPNExists' {

    Context 'Found Nothing' {
    #{userprincipalname -eq $upn} -Server $Server -ErrorAction Stop
        mock -CommandName get-aduser -ParameterFilter {$Server -eq 'doesNotExist.contoso.com' -and $filter -eq {userprincipalname -eq 'glaisne@contoso.com'} -and $errorAction.IsPresent} -MockWith {throw error}
        mock -CommandName get-aduser -MockWith {return $null}

        it 'Cannot find upn'{
            Test-UPNExists -UserPrincipalName 'glaisne@contoso.com' | should be $false
        }

        it 'Cannot access Server' {
            Test-UPNExists -UserPrincipalName 'glaisne@contoso.com' -Server 'doesNotExist.contoso.com' | should throw #"Unable to reach the server specified (doesNotExist.contoso.com) : error"
        }


    }
}