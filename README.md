# PowerBolt

PowerBolt is to streamline [PowerShell](https://github.com/PowerShell/PowerShell) development by having an idea created and then published to the world in minutes without compromising quality.

You may have a PowerShell idea and gone thru the process of preparing this idea into a module so that it's available to be shared. And in doing so you might of created tests, documentation and published it to a repository such as [PowerShell Gallery](https://www.powershellgallery.com/). And perhaps after publishing you may have realized that the version number should of been changed, along with the README file. This process can be cumbersome especially when completing other objectives. PowerBolt attempts to remove this hindrance for you.

Inspired by [Convention over configuration](https://en.wikipedia.org/wiki/Convention_over_configuration) strategy and [Don't repeat yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), PowerBolt expects some structure in order to be used.  Currently that structure can be generated by using [`Install-Template`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Install-Template.md) command by using its 'NewModuleProject' and 'NewScript' templates.

## The Development Flow

- Create
- Develop and Test
- Document
- Publish

### Create

First step is to scaffold files from a [Plaster](https://github.com/PowerShell/Plaster) template. PowerBolt currently has 2 templates available when installed; 'NewModuleProject' and 'NewScript' (for information on templates, visit: [Creating a Plaster Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md)). PowerBolt's [`Install-Template`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Install-Template.md) command is to be used to install Plaster templates. The 'NewModuleProject' template creates a new PowerShell module that includes the *convention* that PowerBolt expects in a module.  The 'DestinationPath' parameter for this template, doesn't have to be in a PowerShell module path (`$Env:PSModulePath`) for it to be imported. PowerBolt will append the PowerShell profile with an `Import-Module` statement. You can verify this by executing the alias for `Get-Content` by passing in the automatic PowerShell variable `$PROFILE`; `gc $PROFILE`. 

After that template is installed (scaffold), you probably want to add your first command to the module. The 'NewScript' template does this.

For an example, the following:

```powershell
PS C:\Users\Alice\projects> Install-Template -TemplateName NewModuleProject -DestinationPath . -ModuleName AcmeTasks -Author Alice
Destination path: C:\Users\Alice\projects
PowerBolt is scaffolding your PowerShell template...

   Create AcmeTasks\src\
   Create AcmeTasks\test\
   Create AcmeTasks\resources\
   Create AcmeTasks\README.md
   Create AcmeTasks\LICENSE
   Create AcmeTasks\AcmeTasks.psm1
   Create AcmeTasks\AcmeTasks.psd1

Scaffolding is completed.
```

Now commands can be added to this module. To do so, the location needs to be changed to the project's root folder and then install 'NewScript' template:

```powershell
PS C:\Users\Alice\projects\AcmeTasks> Install-Template -TemplateName NewScript -ScriptCongruentPath io/file -ScriptName Compress-Data

Destination path: C:\Users\Alice\projects\AcmeTasks
PowerBolt is scaffolding your PowerShell template...

   Create src\io\file\Compress-Data.ps1
   Create test\io\file\Compress-Data.Tests.ps1

Scaffolding is completed.
```

Above the first command is scaffold, 'Compress-Data'. You may have made the conclusion already that 'ScriptCongruentPath' parameter value is the sub-path to the new command file in 'src' and 'test' folder. In an addition to what you may have already determined that has been done by executing these two commands, the root module (AcmeTasks.psm1) has been prefixed with the following:

```powershell
using module .\src\io\file\Compress-Data.ps1
```

And the module manifest (AcmeTasks.psd1) file has its 'FunctionsToExport' key updated to:

```powershell
FunctionsToExport = @(
        'Compress-Data'
    )
```

### Develop and Test

With scaffolding in place, you can develop source file and test against it using [Pester](https://github.com/pester/Pester) (In this step I find TDD practices are beneficial especially the way Pester integrates with [VSCode](https://github.com/Microsoft/vscode) and using CLI with PowerShell).  The source or test file will have code that will not be needed for your needs, you can remove what is not needed.

When you believe you are ready to continue to the next step (Document), call [`Invoke-TestSuiteRunner`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Invoke-TestSuiteRunner.md) to ensure that all test cases that are expected to pass do indeed pass. Although for this example, there is only one test file so the results will be the same as if you tested that file explicitly. This command will be beneficial when more tests are added to this module.

```powershell
PS C:\Users\Alice\projects\AcmeTasks> Invoke-TestSuiteRunner
```

Since `Invoke-TestSuiteRunner` has been executed without an argument, the location of PowerShell must be in the 'AcmeTasks' folder. Alternatively Invoke-TestSuiteRunner can be called with a path value to a module via `Path` parameter, or name value to a module via `Name`. The `Name` parameter has a "validate set" constraint which the elements of that set are retrieved from a `Get-Module` call.

When using Git with GitHub, if your Git branch is named with a valid Semantic Version value, this value will be transposed to the `ModuleVersion` key in the manifest file automatically.  Only simple variants (regex: `\d.\d.\d`) of Semantic Version will work otherwise PowerShell will not be able to import the module. At this step or the next ('Document') you may manually change the module version using [`Update-SemVer`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Update-SemVer.md).

### Document

When development passes testing, generate documentation files powered by [platyPS](https://github.com/PowerShell/platyPS). Using the following command:

```powershell
PS C:\Users\Alice\projects\AcmeTasks> Build-Documentation
```

Used in its most simplest form, calling [Build-Documentation](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Build-Documentation.md) with no parameters is intended to be called inside the root directory of a PowerShell module. And when executed, it will call platyPS commands that will generate or update markdown files for all commands listed in the manifest's `FunctionsToExport` key. It will also execute PowerBolt code that will update a README.md file in the root directory. 

This file will have an API section added or updated, with each exported command's markdown link and synopsis of the command. Such an example can be seen on this very file your are reading.  See the API section of this file below.

### Publish

As mentioned above in the Create section, your module doesn't have to reside in a `$Env:PSModulePath`.  And if it doesn't, you can publish your module without moving it into one of the paths of `$Env:PSModulePath` (which is required by the internal publish command [`Publish-Module`](https://docs.microsoft.com/en-us/powershell/module/powershellget/publish-module)).  PowerBolt will copy your module into one of these paths and will delete it after publishing.

```powershell
PS C:\Users\Alice\projects\AcmeTasks> Publish-ModuleToNuGetGallery
```

To explain further on the reason for this command, by giving an example, I currently have individual PowerShell modules imported (via `Import-Module`) in my PowerShell profile. These modules that are imported to my development directory where they reside on my file system. So when I had to publish a module prior to this command, I would have to copy the folder to a PowerShell module directory. A cumbersome process indeed, so this command has been created to speed up that process. In an addition, PowerBolt can store your API key on your file system using [`Set-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Set-PowerBoltSetting.md) which will be retrieved automatically when [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Publish-ModuleToNuGetGallery.md) is called if its `NuGetApiKey` parameter value is not set. Also remember when PowerBolt creates a module manifest file, it will set the 'Prerelease' key to 'alpha' so that when published it's still accessible to anyone searching for modules with or without being in prerelease stage.  This is to not pollute the repository/gallery with newly created modules that are in its early stages of development. Obviously you can simply remove this value when you feel so, so that the module will not be published in that software stage.

## PowerBolt Config File

When PowerBolt is installed and ran for the first time, it will place a copy of its config file in the ApplicationData (`[Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)`) folder. Use [`Get-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Get-PowerBoltSetting.md) and [`Set-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Set-PowerBoltSetting.md) accordingly.  All values below are default values.

```json
"NuGetApiKey": "",
```

Store your API key that was issued from [PowerShell Gallery](https://www.powershellgallery.com/). When [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Publish-ModuleToNuGetGallery.md) is called this value will be retrieved.


```json
"TurnOnAutoUpdateSemVer": "true",
```

Updates manifest's `ModuleVersion` key when using some of PowerBolt commands. So if your GitHub branch name has simple Semantic Version value, it will be transposed to this manifest key.

## Commands

Below is a complete list of commands exported, in an addition to the main `Install-Template`, `Invoke-TestSuiteRunner`, `Build-Documentation` and `Publish-ModuletoNuGetGallery`commands.

#### [`Add-ModuleToProfile`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Add-ModuleToProfile.md)

Appends content of the PowerShell session's profile with an `Import-Module` statement. 

#### [`Build-Documentation`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Build-Documentation.md)

Creates or updates help documentation files and module's README file. Also creates a XML based help documentation file for PowerShell. 

#### [`Get-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Get-PowerBoltSetting.md)

Retrieves JSON data from `PowerBolt-config.json` or outputs file via `ShowAll` switch. 

#### [`Install-Template`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Install-Template.md)

Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template. 

#### [`Invoke-TestSuiteRunner`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Invoke-TestSuiteRunner.md)

Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester) 

#### [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Publish-ModuleToNuGetGallery.md)

Streamlines publishing a module using `Publish-Module`. 

#### [`Reset-ModuleInProfile`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Reset-ModuleInProfile.md)

Re-enables an `Import-Module` statement in `$PROFILE` to be executed.  

#### [`Set-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Set-PowerBoltSetting.md)

Sets value to JSON data in `PowerBolt-config.json`. 

#### [`Skip-ModuleInProfile`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Skip-ModuleInProfile.md)

Prevents an `Import-Module` statement in `$PROFILE` from executing. 

#### [`Update-ModuleExports`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Update-ModuleExports.md)

Updates root-module and manifest file with commands to be exported. 

#### [`Update-SemVer`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Update-SemVer.md)

Updates the module's semantic version value in the manifest file.

## Q&A

### What conformity does PowerBolt expect in your module?

To see an example of an ideal module, execute the same as what is mentioned in the 'Create' section of this file. Although it's still early in development, I can only recall the following conditions that may have issues:

- Git repository and file URLs are parsed with the expectation of them structured the way GitHub currently does so.

- Module folder, manifest (.psd1) and root module (.psm1) are expected to all have the same name.

- The 'src', 'test' and 'docs' folders inside the module folder are where the source, test and document files respectively are expected to reside.

- Git development branches are expected to be in SemVer format (currently, simple variant only must be used (regex: `\d.\d.\d`)) in order for auto update version to work.

### What advantages does PowerBolt give me?

- By automation, streamlines PowerShell development from creation to publication. This also applies when new commands are added.

- Updates URLs in documentation files (by changing the Git branch name segment for GitHub URLs) to prevent users loading a webpage that is not the version of module they currently have installed.

- Option to add source and test file links to the command's help doc.

- Updates README file with title and synopsis for all exported commands.

- Automatically change ModuleVersion number to Git branch name only if its a simplified  (regex: `\d.\d.\d`) SemVer.

- Automatically imports script files (.ps1) into the root module (.psm1) and exports the function(s) of those files in the module's manifest file (.psd1).

- You can add, skip (disable) and reset (enable) Import-Module statements listed in your PowerShell profile page.

- Just one command to build your module's documentation.  And just one command to test your module.  And just one command to publish your module.  

### What other features are planned to be in PowerBolt?

- To have GitHub repository creation at the same time when `Install-Template` is called to scaffold a new module. So in an addition to what `Install-Template` does currently, and if you have a GitHub account with a [personal access token](https://github.com/settings/tokens), the name of the module will be used to create a new repository in your GitHub account.

- More preferences in config file such as, license type, expected module sub folders ('src', 'test', 'docs'), editor to launch.

- To have module work with other SCM and SCM hosting sites.
