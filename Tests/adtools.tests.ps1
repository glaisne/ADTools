#Import-Module $PSScriptRoot\..\ADTools -Force

Get-ChildItem -Path $PSScriptRoot\..\ADTools\Private\*.ps1 | foreach {. $($_.fullname)}



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
}