using module .\format-inco.psm1

# Imported Modules
# Not Add to .psd1 file

<#
.SYNOPSIS
    pmpacker is a powershell utility module to help with the creation of versioned folders for Powershell Module and Script projects.

.DESCRIPTION
    Build-Module is a function that will create a versioned folder with or without the _v{0}.{1}.{2} tags
    Update the version number in the module manifest and/or script file, and copy files and folders to the destination folder.
    Copying files and folders can be done with the -FilesToCopy and -FoldersToCopy parameters.
    the - Additional files can be copied with the -AdditionalFiles parameter.
    The -IncrementVersion parameter can be used to increment the version number in the module manifest and/or script file.
    The -Manifest and -ScriptFile parameters can be used to rename the .VERSION inside the Module Manifest .psd1 and PSScriptFileInfo .ps1 files.
    The -ApiraBuild parameter can be used to create a .apira file for use with the Apira module.
    The -ZipBuild parameter can be used to create a .zip file of the build folder.

.PARAMETER $SourcePath
    The path to the source folder.

.PARAMETER $DestinationPath
    The path to the destination folder.

.PARAMETER Name
    The name of the module or script/Same Name as the source folder.

.PARAMETER $IncrementVersion
    The version number to increment. Valid values are Major, Minor, Build, and None. Default value is Minor.

.PARAMETER $FilesToCopy
    The files to copy to the destination folder.

.PARAMETER $AdditionalFiles
    The additional files to copy to the destination folder.

.PARAMETER $FoldersToCopy
    The folders to copy to the destination folder.

.PARAMETER $Manifest
    Rename the .VERSION inside the Module Manifest .psd1 file.

.PARAMETER $ScriptFile
    Rename the .VERSION inside the PSScriptFileInfo .ps1 file.

.PARAMETER $ApiraBuild
    Create a .apira file for use with the Apira module.

.PARAMETER $ZipBuild
    Create a .zip file of the build folder.

.EXAMPLE
    Example usage of the function.

        PS> Build-Module -SourcePath G:\devspace\projects\powershell\_repos\pmpacker `
                        -DestinationPath G:\devspace\projects\powershell\_repos\pmpacker\dist `
                        -Name "pmpacker" `
                        -IncrementVersion None `
                        -FilesToCopy @("pmpacker.ps1","license") `
                        -FoldersToCopy @("libs") `
                        -ScriptFile `
                        -Version 0.2.0

.INPUTS
    -SourcePath [string] - The path to the source folder.
    -DestinationPath [string] - The path to the destination folder.
    -Name [string] - The name of the module or script/Same Name as the source folder.
    -IncrementVersion [string] - The version number to increment. Valid values are Major, Minor, Build, and None. Default value is Minor.
    -FilesToCopy [string[]] - The files to copy to the destination folder.
    -AdditionalFiles [string[]] - The additional files to copy to the destination folder.
    -FoldersToCopy [string[]] - The folders to copy to the destination folder.
    -Manifest [switch] - Rename the .VERSION inside the Module Manifest .psd1 file.
    -ScriptFile [switch] - Rename the .VERSION inside the PSScriptFileInfo .ps1 file.
    -ApiraBuild [switch] - Create a .apira file for use with the Apira module.
    -ZipBuild [switch] - Create a .zip file of the build folder.

.OUTPUTS
    None, SdtOut to console.

.NOTES
    This ScriptFile Module was build to help with the creation of versioned folders for Powershell Module 
    and Script projects, before using NUPacker to create a NuGet package.

.LINK
    Related resources or links.
x
#>
function Build-Module {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0)]
        [string]$SourcePath,
        [parameter(mandatory = $true, position = 1)]
        [string]$DestinationPath,
        [parameter(mandatory = $true, position = 2)]
        [string]$Name,
        [parameter(Mandatory = $false, position = 3)]
        [ValidateSet("Major", "Minor", "Build", "None")]
        [string]$IncrementVersion = "Minor", # default value
        [parameter(Mandatory = $false)]
        [string[]]$FilesToCopy = @(),
        [parameter(Mandatory = $false)]
        [string[]]$AdditionalFiles = @(),
        [parameter(Mandatory = $false)]
        [string[]]$ExcludedFiles = @(),
        [parameter(Mandatory = $false)]
        [string[]]$FoldersToCopy = @(),
        [parameter(mandatory = $false)]
        [switch]$Manifest = $false, 
        [parameter(mandatory = $false)]
        [switch]$ScriptFile = $false, 
        [parameter(Mandatory = $false)]
        [switch]$ApiraBuild = $false,
        [parameter(Mandatory = $false)]
        [switch]$Zipbuild = $false,
        [parameter(Mandatory = $false)]
        [string]$Version = "0.1.0"

    )
    begin {
        # Show ASCII Art logo from txt.file
       # Show-ASCIIArtProperties -filepath .\libs\logo.txt
        $SourcePath = (Get-ItemProperty -Path $SourcePath | select-object Fullname).FullName
        $ScriptFilePath = "$SourcePath\$Name`.ps1"
        $ManifestFilePath = "$SourcePath\$Name`.psd1"
        Write-LogTastic -name "pmp" -message "Starting Build Proccess" -type "Action"
        if ((Test-Path $ScriptFilePath) -and !(Test-Path $ManifestFilePath)) {
            $ModuleType = "Script"
            Write-LogTastic -name "pmp" -message "Config: <{ct:yellow:scriptfile}> @{pt:{File=$SourcePath\$Name`.ps1}}" -type "info" -submessage
            try{
                Write-LogTastic -name "pmp" -message "Testing ScriptFile Manifest" -type "info" -submessage
                $ScriptInfo_data = Test-ScriptFileInfo -path $ScriptFilePath
                Write-LogTastic -name "pmp" -message "Success {ct:blue:ScriptFileInfo} @{pt:{Name=$($ScriptInfo_data.Name)}} @{pt:{Version=$($ScriptInfo_data.Version)}}" -Type Success -SubMessage
                }
            catch{
                Write-LogTastic -name "pmp" -message "$($_.exception.message)" -type "error" -submessage
                exit;
            }
        }elseif (!(Test-Path $ScriptFilePath) -and (Test-Path $ManifestFilePath)){
            $ModuleType = "manifest"
            Write-LogTastic -name "pmp" -message "Config: <{ct:yellow:scriptfile}> @{pt:{File=$SourcePath\$Name`.ps1}}" -type "info" -submessage
            try {
                Write-LogTastic -name "pmp" -message "Testing Module Manifest" -type "info"
                $Manifest_data = Test-ModuleManifest -path $ManifestFilePath
                Write-LogTastic -name "pmp" -message "Success <{ct:blue:Manifest}> {pt:{Name:$($Manifest_data.Name)}} {pt:{Version:$($Manifest_data.Version)}}" -type "info" -submessage
            }
            catch {
                Write-LogTastic -name "pmp" -message "$($_.exception.message)" -type "error"  -submessage
                exit;
            } 
        }
        else{
            Write-LogTastic -name "pmp" -message "No Manifest(.psd1) or ScriptFile(.ps1) file found" -type "Error"
            Write-LogTastic -name "pmp" -Message "@{pt:{Source=$SourcePath}}" -type "Error" -submessage
            exit;
        }
    }
    process{

        # Create the destination folder if it doesn't exist
        if (!(Test-Path -Path $DestinationPath)) {
            throw "Destination path $DestinationPath does not exist."
            catch {
                Write-LogTastic -name "pmp" -message "$($_.exception.message)" -type "error"
            }
            Write-LogTastic -name "pmp" -message "Testing destination path@{pt:{DestinationPath=$DestinationPath}}" -type "info"
            try {
                Write-LogTastic -name "pmp" -message "Creating Folder @{pt:{DestinationPath=$DestinationPath}}" -type "action"
                New-Item -ItemType Directory -Path $DestinationPath
            }
            catch [system.exception] {
                Write-LogTastic -name "pmp" -message "$($_.exception.message)" -type "error"
                exit;
            }
        }
        if (!(Test-Path -Path $SourcePath)) { throw "Source path $SourcePath does not exist." }
        
        Write-LogTastic -name "pmp" -message "Checking Build Increment Type..." -type "Success"
        switch ($IncrementVersion) {
            <#
                   !Note This will output a version folder with the module name eg: pspacker_v1.0.0
                   !     use incremental version: none for folder output with _v0.0.0
            #>
            # Major: Increments the major version number by 1 and resets the minor and build numbers to 0.
            "major" { 
                Write-LogTastic -name "pmp" -message "Checking @{pt:{BuildNumbers=major.minor.build(0.0.0)}}" -type "Action"
                # generate the incremental version number from the destination folder based on the max value of the build number {0}.{0}.{0}
                [array]$BuildNumberArray = @(0, 0, 0)
                [array]$versionNumbers = @(0, 0, 0)
                Get-ChildItem -Path $DestinationPath | Where-Object { $_.Name -match "^$($name)_v\d+\.\d+\.\d+$" } | ForEach-Object {
                    Write-LogTastic -name "pmp" -message "Comparing build numbers... @{pt:{BN=$($BuildNumberArray)}}" -type "Success"
                    [array]$current_version_inc = $_.Name -replace "^$($name)_v", '' -split '\.';
                    for ($i = -1; $i -lt $versionNumbers.Length; $i++) {
                        $BuildNumberArray[$i] = [Math]::Max($BuildNumberArray[$i], $current_version_inc[$i])
                    }
                }
                Write-LogTastic -name "pmp" -message "Done." -type "complete"
                # Build Number Formatted = $BuildNumberArray -replace " ","."
                $BuildNumberArray[0]++; Write-LogTastic -name "pmp" -message "Incrementing build Revision @{pt:{Revision=Major-$BuildNumber}}" -type "Action"
                $BuildNumber = $BuildNumberArray -join "," -replace ",", "."
                Write-LogTastic -name "pmp" -message "Generating Build..." -type "action"
                # Generate Version folder string
                $versionedFolderName = "_v{0}.{1}.{2}" -f $BuildNumberArray
                $ouputpath = $DestinationPath + "\" + $name + $versionedFolderName
            }
            # Minor: Increments the minor version number by 1 and resets the build number to 0.
            "minor" { 
                Write-LogTastic -name "pmp" -message "Checking @{pt:{BuildNumbers=major.minor.build(0.0.0)}}" -type "Action"
                # generate the incremental version number from the destination folder based on the max value of the build number {0}.{0}.{0}
                [array]$BuildNumberArray = @(0, 0, 0)
                [array]$versionNumbers = @(0, 0, 0)
                Get-ChildItem -Path $DestinationPath | Where-Object { $_.Name -match "^$($name)_v\d+\.\d+\.\d+$" } | ForEach-Object {
                    Write-LogTastic -name "pmp" -message "Comparing build numbers... @{pt:{BN=$($BuildNumberArray)}}" -type "Success"
                    [array]$current_version_inc = $_.Name -replace "^$($name)_v", '' -split '\.';
                    for ($i = -1; $i -lt $versionNumbers.Length; $i++) {
                        $BuildNumberArray[$i] = [Math]::Max($BuildNumberArray[$i], $current_version_inc[$i])
                    }
                }
                Write-LogTastic -name "pmp" -message "Done." -type "complete"
                # Build Number Formatted = $BuildNumberArray -replace " ","."
                $BuildNumberArray[1]++; Write-LogTastic -name "pmp" -message "Incrementing build Revision @{pt:{Revision=Minor-$BuildNumber}}" -type "Action"
                $BuildNumber = $BuildNumberArray -join "," -replace ",", "."
                Write-LogTastic -name "pmp" -message "Build Module..." -type "action"
                # Generate Version folder string
                $versionedFolderName = "_v{0}.{1}.{2}" -f $BuildNumberArray
                $ouputpath = $DestinationPath + "\" + $name + $versionedFolderName
            }
            # Build: Increments the build number by 1.
            "build" { 
                Write-LogTastic -name "pmp" -message "Checking @{pt:{BuildNumbers=major.minor.build(0.0.0)}}" -type "Action"
                # generate the incremental version number from the destination folder based on the max value of the build number {0}.{0}.{0}
                [array]$BuildNumberArray = @(0, 0, 0)
                [array]$versionNumbers = @(0, 0, 0)
                Get-ChildItem -Path $DestinationPath | Where-Object { $_.Name -match "^$($name)_v\d+\.\d+\.\d+$" } | ForEach-Object {
                    Write-LogTastic -name "pmp" -message "Comparing build numbers... @{pt:{BN=$($BuildNumberArray)}}" -type "Success"
                    [array]$current_version_inc = $_.Name -replace "^$($name)_v", '' -split '\.';
                    for ($i = -1; $i -lt $versionNumbers.Length; $i++) {
                        $BuildNumberArray[$i] = [Math]::Max($BuildNumberArray[$i], $current_version_inc[$i])
                    }
                }
                Write-LogTastic -name "pmp" -message "Done." -type "complete"
                # Build Number Formatted = $BuildNumberArray -replace " ","."
                $BuildNumberArray[2]++; Write-LogTastic -name "pmp" -message "Incrementing build Revision @{pt:{Revision=Build-$BuildNumber}}" -type "Action"
                $BuildNumber = $BuildNumberArray -join "," -replace ",", "."
                Write-LogTastic -name "pmp" -message "Build Module..." -type "action"
                # Generate Version folder string
                $versionedFolderName = "_v{0}.{1}.{2}" -f $BuildNumberArray
                $ouputpath = $DestinationPath + "\" + $name + $versionedFolderName 
            }
            # Noe: Does not increment the version number based on module_v0.0.0 for the folder
            # ! Note that this will overwrite the existing folder if it exists
            # !      and will not increment the build number and will require the -version parameter
            # !      logic CommitFusion.GitAutoVersion function can be used to return the version number
            # !      or script Get-GitAutoVersion can be used to return the version number based on the git repo and the type of commit
            "none" { 
                Write-LogTastic -name "pmp" -message "No Incrementation @{pt:{Revision=Build-NoIncr}}" -type "Action"
                Write-LogTastic -name "pmp" -message "Build Module..." -type "action"
                # Generate Version folder string
                $ouputpath = $DestinationPath + "\" + $name
                $buildNumber = $Version
            }
        }
        Write-LogTastic -name "pmp" -message "File-Operations---------------------\" -type "Info"
        Write-LogTastic -Name pmp -message "Excluded items" -type "Info"
        # Create the versioned folder
        try {
            Write-LogTastic -name "pmp" -message "Creating Folder @{pt:{path=$ouputpath}}" -type "Action" -submessage
            New-Item -ItemType Directory -Path $ouputpath -force | out-null
        }
        catch [System.Exception] {
            Write-LogTastic -name "pmp" -message "-$($_.Exception.Message)" -type "error" -submessage
            exit;
        }
        if ( $ScriptFile -eq $true ) {
            # Update moduleManifest and ScriptFileInfo with the current version number 
            Write-LogTastic -name "pmp" -message "Updpwshating ScriptFile with version number @{pt:{path=$ouputpath}}" -type "Action" -submessage
            $ScriptFile_Version_string = Get-Content "$SourcePath\$name.ps1"
            $ScriptFile_Version_string = $ScriptFile_Version_string -replace '^.VERSION\s(\d+\.\d+\.\d+)\.\d+', ".VERSION $BuildNumber.0"
            Set-Content "$SourcePath\$name.ps1" $ScriptFile_Version_string
        } 
        if ( $Manifest -eq $true ) {
            # Update moduleManifest and ScriptFileInfo with the current version number 
            Write-LogTastic -name "pmp" -message "Updating Manifest with version number @{pt:{path=$ouputpath}}" -type "Action" -submessage
            $Manifest_Version_string = Get-Content "$SourcePath\$name.psd1"
            $Manifest_Version_string = $Manifest_Version_string -replace "ModuleVersion(.*?)'(\d+\.\d+\.\d+\.\d+)'", "ModuleVersion     = '$BuildNumber.0'"
            Set-Content "$SourcePath\$name.psd1" $Manifest_Version_string
        }
        Write-LogTastic -name "pmp" -message "Coping specified build files" -type "info" -submessage
        $FilesToCopy | ForEach-Object {
            try {
                Write-LogTastic -name "pmp" -message "Adding @{pt:{File=$( $_ )}}" -type "action" -submessage
                Copy-Item -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath -Recurse | out-null
            
            }
            catch [System.Exception] {
                Write-LogTastic -name "pmp" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
                exit;
            }
        }
        $AdditionalFiles | ForEach-Object {
            try {
                Write-LogTastic -name "pmp" -message "Adding file @{pt:{File=$( $_ )}}" -type "action" -submessage
                Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath | out-null
            }
            catch [System.Exception] {
                Write-LogTastic -name "pmp" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
                exit;
            }
        }
        $FoldersToCopy | ForEach-Object {
            try {
                Write-LogTastic -name "pmp" -message "Adding folder @{pt:{Folder=$( $_ )}}" -type "action" -submessage
                Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath -Exclude $ExcludedFiles | out-null
            }
            catch [System.Exception] {
                Write-LogTastic -name "pmp" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
                exit;
            }
        }
        if ($UpdateSCIIArt -eq $true) {} #TODO: Update SCII Art, unsure if will include
        if ($zipbuild) {
            Write-LogTastic -name "pmp" -message "Zipping build @{pt{folder:$ouputpath}}" -type "info"
            Compress-Archive -Path $ouputpath -CompressionLevel Optimal -DestinationPath "$ouputpath.zip"
            Write-LogTastic -name "pmp" -message "Done." -type "success"
        }
    }
    end {
        Write-LogTastic -name "pmp" -message "Finished" -type "Complete"
        Write-LogTastic -name "pmp" -message "@{pt:{name=$name}} @{pt:{version=$BuildNumber}}" -type "complete" -submessage
        $buildfoldersize = [math]::round((Get-childitem $ouputpath -Recurse | Measure-Object -Property length -Sum).Sum / 1MB, 2)
                
        #^ HEAD
        write-host "[-| $(Format-Inco -String 'Build Info' -Color Grey) |--o"
        write-host "|" -ForegroundColor yellow
        write-host "|>Build Details _________,"
        write-host "|  Build: $BuildNumber Revision: $IncrementVersion" -ForegroundColor Green
        write-host "|  Size: $buildfoldersize" -ForegroundColor Green
        if ($zipbuild) { write-host "| Zipped: $($name + $ouputpath)" -ForegroundColor Green }
        else { write-host "|  Folder: $($name +"::"+ $ouputpath)" -ForegroundColor Green; }
        
        # MANIFEST CONFIGURATION
        if($Manifest -ne $false){
            Write-Host "|>$(Format-Inco -String 'Module Configuration' -Color Magenta) _________," -Foregroundcolor yellow
            # Parse out Test-ModuleManifest noteproperties that are not null
            # What is configuired in the manifest file will be displayed
            $config_module_data = Test-ModuleManifest -path "$SourcePath\$name.psd1"
            $config_module_data = $config_module_data.psobject.properties.foreach( { $_ | where-object { $_.MemberType -eq "Property" -and ($_.value).count -ne 0 } } )
            # Unable to read ExportedCmdlets from the manifest file, so we will read it from the module data file
            # [System.Management.Automation.CmdletInfo[]] $moduleData.ExportedCmdlets unable to return value via keyname
            # ! Not accessing the object properly, need to fix
            # ? Will use Import-PowerShellDataFile to read the module data file
            #   - ExportedCmdlets
            #   - ExportedFunctions
            #   - ExportedVariables
            #   - ExportedAliases
            #   - NestedModules
            #   - RequiredAssemblies
            #   - ScriptsToProcess
            #   - TypesToProcess
            $moduleData = Import-PowerShellDataFile -Path "$SourcePath\$name.psd1"
            foreach($mo in $config_module_data){
                if (
                    $mo.name -eq 'ExportedCmdlets' -or 
                    $mo.name -eq 'ExportedFunctions' -or 
                    $mo.name -eq 'ExportedVariables' -or 
                    $mo.name -eq 'ExportedAliases' -or 
                    $mo.name -eq 'NestedModules' -or 
                    $mo.name -eq 'RequiredAssemblies' -or 
                    $mo.name -eq 'ScriptsToProcess' -or 
                    $mo.name -eq 'TypesToProcess' -or
                    $mo.name -eq 'ExportedCommands'
                    ) 
                    {
                        switch ($mo.name){
                            'ExportedCmdlets' {
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.CmdletsToExport)" -ForegroundColor Green
                            }
                            'ExportedFunctions' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.FunctionsToExport)"  -ForegroundColor Green
                            }
                            'ExportedVariables' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.VariablesToExport)"  -ForegroundColor Green
                            }
                            'ExportedAliases' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.AliasesToExport)"  -ForegroundColor Green
                            }
                            'NestedModules' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.NestedModules)"  -ForegroundColor Green
                            }
                            'RequiredAssemblies' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.RequiredAssemblies)"  -ForegroundColor Green
                            }
                            'ScriptsToProcess' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.ScriptsToProcess)"  -ForegroundColor Green
                            }
                            'TypesToProcess' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.TypesToProcess)"  -ForegroundColor Green
                            }
                            'ExportedCommands' { 
                                write-host "|  $(Format-Inco -String $($mo.name) -Color Yellow): $($moduleData.ExportedCommands)"  -ForegroundColor Green
                            }

                        }
                }
                else{
                    write-host "|  $(Format-Inco -String $($mo.Name) -Color Yellow): $($mo.value)" -ForegroundColor Green

                }
            }
        }
        # SCRIPTFILE CONFIGURATION
        if($ScriptFile -ne $false){
            Write-Host "|>$(Format-Inco -String 'ScriptFile Configuration' -Color Magenta) _________," -Foregroundcolor yellow
            # Parse out Test-ScriptFileInfo noteproperties that are not null
            # What is configuired in the ScriptFile file will be displayed
            $config_script_data = Test-ScriptFileInfo -path "$SourcePath\$name.ps1"
            $config_script_data = $config_script_data.psobject.properties.foreach( { $_ | where-object { $_.MemberType -eq "NoteProperty" -and $null -ne $_.value } } )
            foreach($sfo in $config_script_data){
                write-host "|  $(Format-Inco -String $sfo.Name -Color Yellow): $($sfo.value)" -ForegroundColor Green
            }

        }
        write-host "o-------------------------------o"
    }
}

Export-ModuleMember -Function Build-Module