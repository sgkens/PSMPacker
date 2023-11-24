@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'psmpacker.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.2.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = 'c7e7262e-8c66-4c0d-9454-9927449c2927'

    # Author of this module
    Author            = 'Garvey k. Snow'

    # Company or vendor of this module
    CompanyName       = 'davilion'

    # Copyright statement for this module
    Copyright         = '2023 Garvey k. Snow. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PSMPacker is a helpful PowerShell utility module designed to assist in the build process of modules and script files.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @("logtastic")

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # Using module in individual cmdlets instead
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Build-Module'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = ''
    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = 'automation', 'build', 'version', 'script', 'powershell', 'utility'

            # A URL to the license for this module.
            LicenseUri   = 'https://choosealicense.com/licenses/mit'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/sgkens/psmpacker.git'

            # A URL to an icon representing this module.
            IconUri      = 'https://gitlab.lab.davilion.online.tk/sgkens/resources/-/blob/main/modules/psmpacker/dist/v1/ccommits-logo_GitIcon_51.20dpi.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://gitlab.lab.davilion.online.tk/powershell/psmpacker/-/blob/main/Releases.md'

            # Prerelease string of this module
            # Prerelease = 'beta'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

