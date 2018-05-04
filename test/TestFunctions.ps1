class TestFunctions {
    static [PSObject]DescribeSetup([string]$ModuleFolder, [string]$TestModuleName) {
        Set-Location -Path $ModuleFolder
        
        # if this is the first test, module may be in "production install" state, if so remove it.
        Split-Path $ModuleFolder -Leaf | `
            Get-Module MK.PowerShell.4PS | `
            Remove-Module -ErrorAction SilentlyContinue

        # MK.PowerShell.4PS will copy config file to this path:
        $ConfigFilePath = "TestDrive:\User\App\Temp\MK.PowerShell-config.ps1"
        
        Get-Item '*.psd1' | Import-Module -ArgumentList $ConfigFilePath

        if ($TestModuleName -ne '') {
            Copy-Item -Path ".\test\testresource\$TestModuleName" -Destination 'TestDrive:\' -Container -Recurse

            Get-Item "TestDrive:\$TestModuleName\$TestModuleName.psd1" | Import-Module

            return @{
                ConfigFilePath   = $ConfigFilePath
                TestManifestPath = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psd1")
                TestModulePath   = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psm1")
            }
        }
        else {
            return @{
                ConfigFilePath = $ConfigFilePath
            }
        }
    }
    
    static [void]DescribeTeardown([string[]]$ModuleName) {
        Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
    }
}