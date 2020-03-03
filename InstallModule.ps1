$ModuleName = "ADTools"
$ModulePath = "C:\Program Files\WindowsPowerShell\Modules"

Copy-Item -Verbose -Path "$PSScriptRoot\$ModuleName" -Destination $ModulePath -Container -Recurse -Force