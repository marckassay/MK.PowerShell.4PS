#
# Module manifest for module 'PSGet_PowerBolt'
#
# Generated by: Marc Kassay
#
# Generated on: 6/25/2018
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'PowerBolt.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.4'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '58323cd9-39e6-45b8-af3a-496c45bb81c6'

    # Author of this module
    Author            = 'Marc Kassay'

    # Company or vendor of this module
    CompanyName       = 'Unknown'

    # Copyright statement for this module
    Copyright         = 'Copyright (c) 2018 Marc Kassay'

    # Description of the functionality provided by this module
    Description       = 'PowerBolt is to quickly create, develop, test, document and publish modules'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(@{ModuleName = 'Plaster'; GUID = 'cfce3c5e-402f-412a-a83a-7b7ee9832ff4'; ModuleVersion = '1.1.3'; }, 
        @{ModuleName = 'platyPS'; GUID = '0bdcabef-a4b7-4a6d-bf7e-d879817ebbff'; ModuleVersion = '0.9.0'; }, 
        @{ModuleName = 'Pester'; GUID = 'a699dea5-2c73-4616-a270-1f7abb777e71'; ModuleVersion = '4.1.1'; })

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess    = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess  = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Add-ModuleToProfile',
        'Build-Documentation',
        'Build-PlatyPSMarkdown',
        'ConvertTo-EnumFlag',
        'Get-MergedPath',
        'Get-MKModuleInfo',
        'Get-PowerBoltSetting',
        'Install-Template',
        'Invoke-TestSuiteRunner',
        'New-ExternalHelpFromPlatyPSMarkdown',
        'New-PowerBoltConfigFile',
        'Publish-ModuleToNuGetGallery',
        'Reset-ModuleInProfile',
        'Search-Items',
        'Set-PowerBoltSetting',
        'Skip-ModuleInProfile',
        'Update-ManifestFunctionsToExportField',
        'Update-ModuleExports',
        'Update-ReadmeFromPlatyPSMarkdown',
        'Update-RootModuleUsingStatements',
        'Update-SemVer'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    # VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList          = 'resources\PowerBolt-config.json', 
    'resources\templates\NewScript\plasterManifest_en-US.xml', 
    'resources\templates\NewScript\parts\Script.ps1', 
    'resources\templates\NewScript\parts\Script.Tests.ps1', 
    'resources\templates\NewModuleProject\plasterManifest_en-US.xml', 
    'resources\templates\NewModuleProject\parts\LICENSE', 
    'resources\templates\NewModuleProject\parts\Module.psm1', 
    'resources\templates\NewModuleProject\parts\README.md'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'development', 'workflow'

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/marckassay/PowerBolt/0.0.4/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/marckassay/PowerBolt'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            Prerelease = '-alpha'

            # Flag to indicate whether the module requires explicit user acceptance for install/update
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable
    
    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI       = 'https://github.com/marckassay/PowerBolt/tree/0.0.4'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

