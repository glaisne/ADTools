$ModuleName   = "ADTools"
$ModulePath   = "C:\Program Files\WindowsPowerShell\Modules"
$TargetPath = "$($ModulePath)\$($ModuleName)"

if(-Not(Test-Path $TargetPath))
{
    mkdir $TargetPath | out-null
}

Copy-Item -Verbose -Path "$pwd\ADTools.psm1" -Destination "$($TargetPath)\ADTools.psm1"
