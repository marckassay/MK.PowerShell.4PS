using module ..\.\TestRunnerSupportModule.psm1

Describe "Test New-MKPowerShellConfigFile" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call New-MKPowerShellConfigFile when no file exists" {
        BeforeEach {
            $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.json'
        }
        AfterEach {

        }

        It "Should copy a new file to the destination folder ('MK.PowerShell')" {
            New-MKPowerShellConfigFile -Path $TestDrive

            Get-Item $FullName | Should -Exist 
        }
    }

    Context "Call New-MKPowerShellConfigFile when file exists" {
        It "Should prompt user about exisiting file" {
            InModuleScope MK.PowerShell.Flow {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After
                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.json'
                Get-Module MK.PowerShell.Flow | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*MK.PowerShell-config.json') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName 

                ### TEST
                Mock WriteWarningWrapper { $true }
                
                Get-Item $FullName | Should -Exist
                
                New-MKPowerShellConfigFile -Path $TestDrive
                
                Assert-MockCalled WriteWarningWrapper 1
                
                Get-Item $FullName | Should -Exist

                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            }
        }

        It "Should not prompt user about exisiting file" {
            InModuleScope MK.PowerShell.Flow {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After

                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.json'
                Get-Module MK.PowerShell.Flow | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*MK.PowerShell-config.json') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName 

                ### TEST
                Mock WriteWarningWrapper { $true }

                Get-Item $FullName | Should -Exist 

                New-MKPowerShellConfigFile -Path $TestDrive -Force
                # NOTE: although this mock wasnt called '1' time in this 'It', this is from the 
                # previous 'It' block
                Assert-MockCalled WriteWarningWrapper 1

                Get-Item $FullName | Should -Exist
                
                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            } 
        }
    }
}