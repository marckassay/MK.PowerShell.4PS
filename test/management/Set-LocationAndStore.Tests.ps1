using module ..\.\TestFunctions.psm1
Describe "Test Set-LocationAndStore" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('MockModuleB')

        Push-Location -StackName LocationAndStoreTest
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()

        Pop-Location -StackName LocationAndStoreTest
    }
    
    Context "When 'TurnOnHistoryRecording' is set to true" {
        Set-MKPowerShellSetting -Name 'TurnOnRememberLastLocation' -Value $true 
        Set-MKPowerShellSetting -Name 'TurnOnHistoryRecording' -Value $true 

        Mock Set-MKPowerShellSetting -ModuleName MK.PowerShell.4PS

        It "Should change and store this location: '<Val>'" -TestCases @(
            @{ Path = "C:\"; Val = "C:\"},
            @{ Path = "C:\Temp"; Val = "C:\Temp"}
            @{ Path = "..\"; Val = "C:\"}
        ) {
            Param($Path, $Val)

            Set-LocationAndStore -Path $Path

            Get-Location | Should -Be $Val
    
            Assert-MockCalled Set-MKPowerShellSetting -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter { 
                $Name -eq 'LastLocation' -and $Value -like $Val
            }
        }
    }
}