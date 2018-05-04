$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
Import-Module "$MODULE_FOLDER\test\TestFunctions.ps1" -Global -Force 

Describe "Test Update-ManifestFunctionsToExportField" {
    
    BeforeEach {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, 'TestModuleA')
    }
    AfterEach {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestFunctions'))
    }

    Context "Call Update-RootModuleUsingStatements and pipe result" {

        It "Should overwrite the default value ('@()') for FunctionsToExport field with 'using' statements" {
            Update-RootModuleUsingStatements -Path $__.TestModulePath | Update-ManifestFunctionsToExportField

            $FunctionNames = Test-ModuleManifest $__.TestManifestPath | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
            $FunctionNames -contains 'Set-CFunction' | Should -Be $true
        }
    }
}