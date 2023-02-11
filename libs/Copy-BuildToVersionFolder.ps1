using module ..\..\quicklog\libs\New-Quicklog.ps1
using module ..\..\ASCIIArtProperties\Show-ASCIIArtProperties.ps1
function Copy-BuildToVersionFolder{
    [CmdletBinding()]
    param (
        [parameter(mandatory=$true)][string]$SourcePath,
        [parameter(mandatory=$true)][string]$DestinationPath,
        [parameter(mandatory = $false, ValueFromPipeline = $true)][switch]$psmm = $false, # Renames the .VERSION inside the Module Manifest .psd1
        [parameter(mandatory = $false, ValueFromPipeline = $true)][switch]$pssi = $false, # Renames the .VERSION inside the PSScriptFileInfo .ps1
        [string[]]$FilesToCopy = @(),
        [string[]]$AdditionalFiles = @(),
        [string[]]$FoldersToCopy = @(),
        [ValidateSet("major", "minor", "build")][string]$IncrementVersion = "build", # default value
        [parameter(ValueFromPipeline=$true)][switch]$apiraBuild = $false
    )
    Show-ASCIIArtProperties -file $SourcePath\libs\logo.txt
    new-quicklog -name "BTVF" -message "Init Starting Build Proccess for @{pt:{RepositoryFolder=$SourcePath}}" -type "info"
    # Create the destination folder if it doesn't exist
    if (!(Test-Path -Path $DestinationPath)) {
        throw "Destination path $DestinationPath does not exist."
        catch {
            new-quicklog -name "BTVF" -message "$($_.exceptio.message)" -type "error"
        }
        new-quicklog -name "BTVF" -message "Testing destination path@{pt:{DestinationPath=$DestinationPath}}" -type "info"
        try{
            new-quicklog -name "BTVF" -message "Creating Folder @{pt:{DestinationPath=$DestinationPath}}" -type "action"
            New-Item -ItemType Directory -Path $DestinationPath
        }
        catch [system.exception]{
            new-quicklog -name "BTVF" -message "$($_.exceptio.message)" -type "error"
        }
    }
    if (!(Test-Path -Path $SourcePath)) { throw "Source path $SourcePath does not exist." }
    new-quicklog -name "BTVF" -message "Generating @{pt:{BuildNumber=v{0}.{0}.{0}}}" -type "Action"
    # Get the current version number
    [array]$BuildNumberArray = @(0,0,0)
    [array]$versionNumbers = @(0,0,0)
    Get-ChildItem -Path $DestinationPath |
    Where-Object { $_.Name -match '^v\d+\.\d+\.\d+$' } | 
    ForEach-Object {
        [array]$current_version_inc = $_.Name -replace '^v', '' -split '\.';
        for ($i=-1; $i -lt $versionNumbers.Length; $i++)
        {
            $BuildNumberArray[$i] = [Math]::Max($BuildNumberArray[$i], $current_version_inc[$i])
            new-quicklog -name "BTVF" -message "Comparing build numbers..." -type "Success"
        }
        new-quicklog -name "BTVF" -message "Done." -type "Completed"
    }
    new-quicklog -name "BTVF" -message "Checking Build Increment Type..." -type "Success"
    switch ($IncrementVersion) {
        "major" { $BuildNumberArray[0]++; new-quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Major,$($BuildNumberArray[0])}}" -type "Action" }
        "minor" { $BuildNumberArray[1]++; new-quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Minor,$($BuildNumberArray[1])}}" -type "Action" }
        "build" { $BuildNumberArray[2]++; new-quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Build,$($BuildNumberArray[2])}}" -type "Action" }
    }

    # Generator Version folder string
    $versionedDestinationPath = Join-Path -Path $DestinationPath -ChildPath ('v{0}.{1}.{2}' -f $BuildNumberArray)
    new-quicklog -name "BTVF" -message "-File-Operations---------------------\" -type "Info"
    # Create the versioned folder
    try {
        new-quicklog -name "BTVF" -message "Creating VersionBuildFolder @{pt:{VersionBuildFolder=$versionedDestinationPath}}" -type "Action" -submessage
        New-Item -ItemType Directory -Path $versionedDestinationPath
        new-quicklog -name "BTVF" -message "-Creating VersionBuildFolder @{pt:{VersionBuildFolder=$versionedDestinationPath}}" -type "success" -submessage
    }
    catch [System.Exception] {
        new-quicklog -name "BTVF" -message "-$($_.Exception.Message)" -type "error" -submessage
    }
    new-quicklog -name "BTVF" -message "-Coping specified build files" -type "info" -submessage
    $FilesToCopy | ForEach-Object {
        try {
          new-quicklog -name "BTVF" -message "-Coping file @{pt:{File=$( $_.name )}}" -type "action" -submessage
         Copy-Item -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath -Recurse
          
        }
        catch [System.Exception]{
            <#Do this if a terminating exception happens#>
        }
    }
    $AdditionalFiles | ForEach-Object {
        Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath
    }
    $FoldersToCopy | ForEach-Object {
        Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath
    }
    #BuildNumberFormatted = $BuildNumberArray -replace " ","."
    $BuildNumber = $BuildNumberArray -join "," -replace ",","."
    # If APIRA will parse info for apira build data and update the version number and write back to json file
    if ( $apiraBuild -eq $true) {
        $apira_build_data = Get-Content -Path "$SourcePath\apira_build_data.json" | ConvertFrom-Json
        $apira_build_data.Version = "v$BuildNumber"
        $apira_build_data | ConvertTo-Json | out-file -Path "$SourcePath\apira_build_data.json"
    }
    if( $pssi -eq $true ){
        # Update moduleManifest and ScriptFileInfo with the current version number 
        $PSSI_Version_string = Get-Content "$SourcePath\$(Split-Path -Path $pwd -Leaf).ps1"
        $PSSI_Version_string = $PSSI_Version_string -replace '^.VERSION\s(\d+\.\d+\.\d+)\.\d+', ".VERSION $BuildNumber.0"
        Set-Content "$SourcePath\$($(Split-Path -Path $pwd -Leaf)).ps1" $PSSI_Version_string
    }
    if ( $psmm -eq $true ) {
        # Update moduleManifest and ScriptFileInfo with the current version number 
        $PSMM_Version_string = Get-Content "$SourcePath\$(Split-Path -Path $pwd -Leaf).psd1"
        $PSMM_Version_string = $PSSI_Version_string -replace '^.VERSION\s(\d+\.\d+\.\d+)\.\d+', ".VERSION $BuildNumber.0"
        Set-Content "$SourcePath\$($(Split-Path -Path $pwd -Leaf)).psd1" $PSMM_Version_string       
    }
    if($UpdateSCIIArt -eq $true){

    }
}

 #Copy-BuildToVersionFolder -SourcePath G:\devspace\projects\powershell\quicklog -DestinationPath G:\devspace\projects\powershell\quicklog\dist -RepoName "" -FilesToCopy @("quicklog.ps1") -FoldersToCopy @("libs") -IncrementVersion "build" -apira