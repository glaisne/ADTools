import-module $PSScriptRoot\..\ADTools -Force

Describe 'Convert-msExchRecipienttypeDetails' {
    Context 'Basic tests' {
        IT 'simple call should not throw' {
            {Convert-msExchRecipientTypeDetails -msExchRecipientTypeDetails 1} | should not throw
        }
        IT '1 should return "UserMailbox"'{
            Convert-msExchRecipientTypeDetails -msExchRecipientTypeDetails 1 | should be 'UserMailbox'
        }
        IT 'null msExchRecipientTypeDetails returns "unknown"'{
            Convert-msExchRecipientTypeDetails -msExchRecipientTypeDetails $null | should be 'unknown'
        }
        IT 'Empty string msExchRecipientTypeDetails returns "unknown"'{
            Convert-msExchRecipientTypeDetails -msExchRecipientTypeDetails [string]::Empty | should be 'unknown'
        }
    }
}