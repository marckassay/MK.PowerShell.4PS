# MK.PowerShell.Flow

Created to streamline coding by primarily completing an objective of: having a [PowerShell](https://github.com/PowerShell/PowerShell) idea that is published to the world in minutes without compromising quality of module.

You may have a PowerShell idea and gone thru the process of preparing this idea into a module so that it's available to be shared. And in doing so you might of created tests, documentation and published it to a repository such as [PowerShell Gallery](https://www.powershellgallery.com/). This can be cumbersome especially when completing other objectives. Flow attempts to remove this hinderance for you. 

Another objective of Flow is to encourage publishing small, monad (how apropos!) scripts instead of a monolithic module in hopes to have it adapted in other modules. The rationale of Flow is to have several script files (.ps1) and one root module (.psm1). Where as individual script files can be published and can be exported when publishing the root module.

## The Development Flow

- Create
- Develop and Test
- Document
- Publish

### Create

First step is to scaffold files from a custom [Plaster](https://github.com/PowerShell/Plaster) template. For information on templates (plaster manifests) [Creating a Plaster Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md). Using Flow, the [`Install-Template`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Install-Template.md) command guides you after choosing a template for its first parameter followed with dynamic constraints for its remaining arity.

For an example, the following:

```powershell
PS C:\Users\Alice\Apps> Install-Template -PlasterTemplatePath '..\PlasterTemplates\NewMVC\plasterManifest_en-US.xml' -AppName 'CoffeeApp'
```

Although the Plaster manifest file is not shown, you can be assured that a variable of `PLASTER_PARAM_AppName` resides in its contents. And with Plaster you can scaffold files with variables (tokens) inside them that can be replaced with values such as the one given to AppName, for this instance.

### Develop and Test

With scaffolding in place, develop source file and test against that file using [Pester](https://github.com/pester/Pester). In this step I find TDD practices are beneficial especially the way Pester integrates with [VSCode](https://github.com/Microsoft/vscode) and using CLI with PowerShell.

When you believe you are ready to document and publish, call [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Invoke-TestSuiteRunner.md) to ensure that all test cases that are expected to pass, do indeed pass.

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Invoke-TestSuiteRunner
```

Since `Invoke-TestSuiteRunner` has been executed without an argument, therefore, the location of 'CoffeeApp' must be a PowerShell module. Alternatively Invoke-TestSuiteRunner can be called with a path value to a module via `Path` parameter, or name value to a module via `Name`. Those 2 parameters belong to a validateset which most of Flow commands when applicable has these sets.

If your GitHub repository branch is named with a valid Semantic Version value ([regex pattern](https://regex101.com/library/gG8cK7)), this value will be transposed to the `ModuleVersion` key in the manifest file automatically. At this step or the next ('Document') you may manually change the module version using [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Update-SemVer.md).

### Document

When development passes testing, generate documentation files powered by [platyPS](https://github.com/PowerShell/platyPS). Using the following command:

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Build-Documentation
```

Used in the most simplest form, calling [Build-Documentation](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Build-Documentation.md) with no parameters is intended to be called inside the root directory of a PowerShell module. And when executed, it will call platyPS commands that will generate or update markdown files for all commands listed in the manifest's `FunctionsToExport` key. It will also execute Flow code that will update a README.md file in the root directory. 

This file will have an API section added or updated, with each exported command's markdown link and synopsis of the command. Such an example can be seen on this every file below, see the API section of this file.

### Publish

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Publish-ModuleToNuGetGallery
```

I assume most developers organize their projects or repository in some location on their machine and resist having them elsewhere. If so, [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) may help by deploying your module directory in a "PowerShell" module directory and publish it from there. Afterwards it will remove the directory and keep the original untouched.

To explain further on the reason for this command, by giving an example, I currently have individual PowerShell modules listed in my PowerShell profile. These modules that are listed point to my development directory where they reside on my file system. So when I had to publish a module prior to this command, I would have to copy the folder to a PowerShell module directory. A cumbersome process indeed, so this command has been created to speed up that process. In an addition Flow can store your API key on your file system using [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Set-MKPowerShellSetting.md) which will be retrieved automatically when [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) is called if its `NuGetApiKey` parameter value is not set.

## What conformity does Flow expect in your module?

Although it's still early in development, I can only recall the following conditions that may have issues:

+ URLs are parsed and validated with the expectation of them structured the way GitHub has them.  

+ Module folder, manifest and root module are expected to all have the same the name.

+ The 'src', 'test' and 'docs' folders inside the module folder are where the source, test and document files respectively are expected to reside.

+ Git development branches are expected to be in SemVer format (currently, simple variant only must be used (regex: \d\.\d\.\d)) in order for auto update version to work.

## Flow Config File

When Flow is installed and ran for the first time, it will place a copy of its config file in the ApplicationData folder. Use [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Get-MKPowerShellSetting.md) and [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Set-MKPowerShellSetting.md) accordingly.  All values below are default values.

```json
"TurnOnBackup": "false",
"BackupPolicy": "auto",
"Backups": [{
    "Destination": "",
    "Path": "",
    "UpdatePolicy": ""
  }],
```

Ideal for moving setting files to perhaps a cloud drive such as Google Drive or Microsoft OneDrive.

```json
"TurnOnHistoryRecording": "true",
"HistoryLocation": "",
```

Stores histories and imports them into current session so that you can view history spanning perhaps days instead of just the current session.

```json
"TurnOnRememberLastLocation": "true"
"LastLocation": "",
```

When PowerShell is restarted, it will set the location to the last known location.

```json
"NuGetApiKey": "",
```

Store your API key that was issued from [PowerShell Gallery](https://www.powershellgallery.com/). When [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) is called this value will be retrieved.

```json
"TurnOnAvailableUpdates": "true",
```

Checks for updates when PowerShell starts-up.

```json
"TurnOnAutoUpdateSemVer": "true",
```

Updates manifest's `ModuleVersion` key when using some of Flow commands.  Read Flow 101 section for more information.

```json
"TurnOnExtendedFormats": "true",
```

Enables the following formats:
+ Microsoft.PowerShell.Commands.HistoryInfo
Formats output from `Get-History`

+ System.Management.Automation.PSModuleInfo
Formats output from `Get-Module`

```json
"TurnOnExtendedTypes": "true",
```

Enables the following commands for types:
+ System.Byte[] 
`ToBinaryNotation()`
`ToUnicode()`

+ System.String
`ToBase64()`
`FromBase64()`
`MatchCount()`

```json
"TurnOnQuickRestart": "true"
```

Using the alias `pwsh` and `pwsha` will restart PowerShell.  The former restarts PowerShell in Administrative mode.

## Commands

#### [`Add-ModuleToProfile`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Add-ModuleToProfile.md)

Appends content of the PowerShell session's profile with an `Import-Module` statement. 

#### [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Build-Documentation.md)

Creates or updates help documentation files and module's README file. Also creates a XML based help documentation file for PowerShell. 

#### [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Get-MKPowerShellSetting.md)

Retrieves JSON data from `MK.PowerShell-config.json` or outputs file via `ShowAll` switch. 

#### [`Install-Template`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Install-Template.md)

Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template. 

#### [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Invoke-TestSuiteRunner.md)

Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester) 

#### [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Publish-ModuleToNuGetGallery.md)

Streamlines publishing a module using `Publish-Module`. 

#### [`Reset-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Reset-ModuleInProfile.md)

Re-enables an `Import-Module` statement in `$PROFILE` to be executed.  

#### [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Set-MKPowerShellSetting.md)

Sets value to JSON data in `MK.PowerShell-config.json`. 

#### [`Skip-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Skip-ModuleInProfile.md)

Prevents an `Import-Module` statement in `$PROFILE` from executing. 

#### [`Update-ModuleExports`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Update-ModuleExports.md)

Updates root-module and manifest file with commands to be exported. 

#### [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Update-SemVer.md)

Updates the module's semantic version value in the manifest file.
