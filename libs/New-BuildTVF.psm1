using module ..\..\quicklog\libs\New-Quicklog.ps1
using module ..\..\ASCIIArtProperties\Show-ASCIIArtProperties.ps1
function New-BuildTVF {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0)]
        [string]$SourcePath,
        [parameter(mandatory = $true, position = 1)]
        [string]$DestinationPath,
        [parameter(mandatory = $true, position = 2)]
        [string]$Name,
        [parameter(Mandatory = $false, position = 3)]
        [ValidateSet("major", "minor", "build")]
        [string]$IncrementVersion = "build", # default value
        [parameter(Mandatory = $false)]
        [string[]]$FilesToCopy = @(),
        [parameter(Mandatory = $false)]
        [string[]]$AdditionalFiles = @(),
        [parameter(Mandatory = $false)]
        [string[]]$FoldersToCopy = @(),
        [parameter(mandatory = $false, ValueFromPipeline 000= $true)]
        [switch]$Psmm = $false, # Renames the .VERSION inside the Module Manifest .psd1
        [parameter(mandatory = $false, ValueFromPipeline = $true)]
        [switch]$Pssi = $false, # Renames the .VERSION inside the PSScriptFileInfo .ps1
        [parameter(ValueFromPipeline = $true)]
        [switch]$ApiraBuild = $false,
        [parameter(ValueFromPipeline = $true)]
        [switch]$Zipbuild = $false

    )
    # Show ASCII Art logo from txt.file
    Show-ASCIIArtProperties -filepath .\libs\logo.txt
    
    New-Quicklog -name "BTVF" -message "Starting Build Proccess @{pt:{Folder=$SourcePath}}" -type "info"
    # Create the destination folder if it doesn't exist
    if (!(Test-Path -Path $DestinationPath)) {
        throw "Destination path $DestinationPath does not exist."
        catch {
            New-Quicklog -name "BTVF" -message "$($_.exception.message)" -type "error"
        }
        New-Quicklog -name "BTVF" -message "Testing destination path@{pt:{DestinationPath=$DestinationPath}}" -type "info"
        try {
            New-Quicklog -name "BTVF" -message "Creating Folder @{pt:{DestinationPath=$DestinationPath}}" -type "action"
            New-Item -ItemType Directory -Path $DestinationPath
        }
        catch [system.exception] {
            New-Quicklog -name "BTVF" -message "$($_.exception.message)" -type "error"
        }
    }
    if (!(Test-Path -Path $SourcePath)) { throw "Source path $SourcePath does not exist." }
    New-Quicklog -name "BTVF" -message "Checking @{pt:{BuildNumbers=major.minor.build(0.0.0)}}" -type "Action"
    # generate the incremental version number from the destination folder based on the max value of the build number {0}.{0}.{0}
    [array]$BuildNumberArray = @(0, 0, 0)
    [array]$versionNumbers = @(0, 0, 0)
    Get-ChildItem -Path $DestinationPath | Where-Object { $_.Name -match "^$($name)_v\d+\.\d+\.\d+$" } | ForEach-Object {
        New-Quicklog -name "BTVF" -message "Comparing build numbers... @{pt:{BN=$($BuildNumberArray)}}" -type "Success"
        [array]$current_version_inc = $_.Name -replace "^$($name)_v", '' -split '\.';
        for ($i = -1; $i -lt $versionNumbers.Length; $i++) {
            $BuildNumberArray[$i] = [Math]::Max($BuildNumberArray[$i], $current_version_inc[$i])
        }
    }
    New-Quicklog -name "BTVF" -message "Done." -type "complete"
    # Build Number Formatted = $BuildNumberArray -replace " ","."
    
    New-Quicklog -name "BTVF" -message "Checking Build Increment Type..." -type "Success"
    switch ($IncrementVersion) {
        "major" { $BuildNumberArray[0]++; New-Quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Major-$BuildNumber}}" -type "Action" }
        "minor" { $BuildNumberArray[1]++; New-Quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Minor-$BuildNumber}}" -type "Action" }
        "build" { $BuildNumberArray[2]++; New-Quicklog -name "BTVF" -message "Incrementing build Revision @{pt:{Revision=Build-$BuildNumber}}" -type "Action" }
    }
    $BuildNumber = $BuildNumberArray -join "," -replace ",", "."
    New-Quicklog -name "BTVF" -message "Generating Build..." -type "action"
    # Generate Version folder string
    $versionedFolderName = "_v{0}.{1}.{2}" -f $BuildNumberArray
    $ouputpath = $DestinationPath + "\" + $name + $versionedFolderName
    New-Quicklog -name "BTVF" -message "File-Operations---------------------\" -type "Info"
    # Create the versioned folder
    try {
        New-Quicklog -name "BTVF" -message "Creating Version Folder @{pt:{path=$ouputpath}}" -type "Action" -submessage
        New-Item -ItemType Directory -Path $ouputpath | out-null
    }
    catch [System.Exception] {
        New-Quicklog -name "BTVF" -message "-$($_.Exception.Message)" -type "error" -submessage
    }
    if ( $pssi -eq $true ) {
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
    New-Quicklog -name "BTVF" -message "Coping specified build files" -type "info" -submessage
    $FilesToCopy | ForEach-Object {
        try {
            New-Quicklog -name "BTVF" -message "Adding @{pt:{File=$( $_ )}}" -type "action" -submessage
            Copy-Item -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath -Recurse | out-null
          
        }
        catch [System.Exception] {
            New-Quicklog -name "BTVF" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
        }
    }
    $AdditionalFiles | ForEach-Object {
        try {
            New-Quicklog -name "BTVF" -message "Adding file @{pt:{File=$( $_ )}}" -type "action" -submessage
            Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath | out-null
        }
        catch [System.Exception] {
            New-Quicklog -name "BTVF" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
        }
    }
    $FoldersToCopy | ForEach-Object {
        try {
            New-Quicklog -name "BTVF" -message "Adding folder @{pt:{Folder=$( $_ )}}" -type "action" -submessage
            Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $ouputpath | out-null
        }
        catch [System.Exception] {
            New-Quicklog -name "BTVF" -message "Error @{pt:{Error=$( $_.Exception.Message )}}" -type "error" -submessage
        }
    }
    if ($UpdateSCIIArt -eq $true) {} #TODO: Update SCII Art, unsure if will include
    if ($zipbuild) {
        new-quicklog -name "BTVF" -message "Zipping build @{pt{folder:$ouputpath}}" -type "info"
        New-Archive -Path $ouputpath -CompressionLevel Optimal -DestinationPath "$ouputpath.zip"
        new-quicklog -name "BTVF" -message "Done." -type "success"
    }
    $buildfoldersize = (Get-childitem $ouputpath -Recurse | Measure-Object -Property length -Sum).Sum / 1MB
    write-host "o--|( Build Complete )--------------------o"
    write-host "||> Ouput: $ouputpath" -ForegroundColor yellow
    write-host "o--|( Details )--------------------o"
    write-host "||> Build: $BuildNumber Revision: $IncrementVersion" -ForegroundColor Green
    write-host "||> Size: $buildfoldersize" -ForegroundColor Green
    if ($zipbuild) { write-host "||> Zipped: $($name + $ouputpath)" -ForegroundColor Green }
    else { write-host "||> Folder: $($name + $ouputpath)" -ForegroundColor Green; }
    write-host "o-------------------------------o"
}

Export-ModuleMember -Function New-BuildTVF