$RegistryKey = 'HKCU:\SOFTWARE\PowerShell'

function Set-BackupProfileLocation {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )

    Set-ItemProperty -Path $RegistryKey -Name BackupProfileLocation -Value $Value
}
Export-ModuleMember -Function Set-BackupProfileLocation

# backup this profile to Google Drive in case if working on new computer or this 
# computer gets reformatted which might be forgotten. 
function Backup-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Destination
    )

    if (-not $Destination) {
        try {
            if ( $(Test-Path $RegistryKey -ErrorAction SilentlyContinue) -eq $True ) {

                $Destination = Get-ItemPropertyValue -Path $RegistryKey -Name BackupProfileLocation

                if ((Test-Path $Destination -PathType Container) -eq $False) {
                    New-Item $Destination -ItemType Directory
                }
                Copy-Item -Path $PROFILE -Destination $Destination -Force

                Write-Host "BackupProfileLocation has been updated"
            }
        }
        catch {
            Write-Host "No BackupProfileLocation value has been set."
        }
    }
}
Export-ModuleMember -Function Backup-PowerShellProfile

function Update-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Path = "$PSScriptRoot\Microsoft.VSCode_profile.ps1",

        [Parameter(Mandatory = $False)]
        [string[]]$Include
    )
    # overwrite $Path with the following...
    $VSCode_Profile_Mesg = '# THIS FILE IS AUTOGENERATED THAT IS OVERWRITTEN BY Microsoft.PowerShell_profile.ps1 FILE'
    Set-Content $Path -Value $VSCode_Profile_Mesg  -Force | Out-Null

    # include only...
    Get-Content $PROFILE | `
        ForEach-Object {
        if ($_.StartsWith('Import-Module')) {
            $_
        }
    } | `
        Add-Content $Path -Force

    # append the following...
    Add-Content $Path -Value @"

# overwrite alias 'sl' with SaveLocation module's Set-LocationAndStore
Set-Alias sl Set-LocationAndStore -Force
"@ -Force
}
Export-ModuleMember -Function Update-PowerShellProfile

function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Start-Process -FilePath "pwsh.exe" -Verb open
    }
    exit
}
Export-ModuleMember -Function Update-PowerShellProfile

function Restart-PWSHAdim {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Start-Process -FilePath "pwsh.exe" -Verb runAs
    }
    exit
}
Export-ModuleMember -Function Restart-PWSHAdim

function Publish-Module {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$NuGetApiKey
    )

    if (-not $Path -or -not $NuGetApiKey) {
        Push-Location

        Set-Location -Path $RegistryKey

        if (-not $Path) {
            $Path = Get-ItemPropertyValue -Name LastLocation
        }

        if (-not $NuGetApiKey) {
            $NuGetApiKey = Get-ItemPropertyValue -Name NuGetApiKey
        }

        Pop-Location
    }
    
    if ((Test-Path -Path $Path -PathType Container) -eq $False) {
        $Path = Split-Path -Path $Path -Parent
    }

    Copy-Item -Path $Path -Destination "$PSScriptRoot\Modules" -Exclude '.git', '.vscode' -Recurse -Force -Verbose -Container
    Publish-Module -Name $Path -NuGetApiKey $NuGetApiKey -Verbose -Confirm
}
Export-ModuleMember -Function Publish-Module

function Set-NuGetApiKey {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )

    Set-ItemProperty -Path $RegistryKey -Name NuGetApiKey -Value $Value
}
Export-ModuleMember -Function Set-NuGetApiKey

function Set-LocationAndStore {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$LiteralPath,

        [switch]$PassThru
    )

    if ($Path) {
        Set-Location -Path $Path
    }
    else {
        Set-Location -LiteralPath $LiteralPath
    }

    Set-ItemProperty -Path $RegistryKey -Name LastLocation -Value (Get-Location) -PassThru:$PassThru.IsPresent
}
Export-ModuleMember -Function Set-LocationAndStore

function Restore-Settings {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    if ( $(Test-Path $RegistryKey -ErrorAction SilentlyContinue) -eq $True ) {
        Push-Location

        Set-Location -Path $RegistryKey

        $LastLocation = Get-ItemPropertyValue -Name LastLocation

        Pop-Location

        if ( $(Test-Path $LastLocation -ErrorAction SilentlyContinue) -eq $True ) {
            Set-Location $LastLocation

            Write-Host "Restored LastLocation"
        }
    }
    else {
        $InitalLocation = Get-Location

        Push-Location

        Set-Location -Path 'HKCU:\SOFTWARE\'

        $RegKey = New-Item -Name 'PowerShell' 
        $RegKey | New-ItemProperty -Name LastLocation -Value $InitalLocation -PropertyType String
        $RegKey | New-ItemProperty -Name NuGetApiKey -Value '' -PropertyType String
        $RegKey | New-ItemProperty -Name BackupProfileLocation -Value '' -PropertyType String

        Pop-Location
        
        Write-Host "New registry key for PowerShell has been created."
    }
}

function Start-PowerShellSession {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    
    Restore-Settings

    $job = Start-Job { 
        Start-Sleep -Seconds 5
    }
    
    Register-ObjectEvent $job -EventName StateChanged -SourceIdentifier JobEnd -Action {
        if ($sender.State -eq 'Completed') {
            Backup-PowerShellProfile
            Update-PowerShellProfile
            Unregister-Event JobEnd
            Remove-Job $job
        } 
    } | Out-Null
}
Start-PowerShellSession 


# overwrite alias 'sl' with SaveLocation module's Set-LocationAndStore
Set-Alias sl Set-LocationAndStore -Force
Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'."

Set-Alias pwsh Restart-PWSH -Force
Write-Host "'pwsh' alias is now mapped to 'Restart-PWSH'."

Set-Alias pwsha Restart-PWSHAdim
Write-Host "'pwsha' alias is now mapped to 'Restart-PWSHAdmin'."