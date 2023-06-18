function Copy-BuildToVersionFolder{
    [CmdletBinding()]
    param (
        [parameter(mandatory=$true)]
        [string]$SourcePath,
        [parameter(mandatory=$true)]
        [string]$DestinationPath,
        [parameter(mandatory = $false)]
        [string[]]$FilesToCopy = @(),
        [parameter(mandatory = $false)]
        [string[]]$AdditionalFiles = @(),
        [parameter(mandatory = $false)]
        [string[]]$FoldersToCopy = @(),
        [parameter(mandatory = $false)]
        [ValidateSet("major", "minor", "build")]
        [string]$IncrementVersion = "build",
        [parameter(ValueFromPipeline=$true)]
        [switch]$apiraBuild = $false
    )
    write-host -foregroundColor Cyan "|| BUILD MAKER ||"
    write-host -foregroundColor yellow "||-----> Starting Build Proccess"
    # Create the destination folder if it doesn't exist
    if (!(Test-Path -Path $DestinationPath)) {
        write-host -foregroundColor yellow "||-----> Testing destination path: $DestinationPath"
        New-Item -ItemType Directory -Path $DestinationPath
    }
    if( $apiraBuild -eq $true){
        $apira_build_data = Get-Content -Path "$psscriptroot/apira_build_data.json"|ConvertFrom-Json
    }
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
        }
    }
    switch ($IncrementVersion) {
        "major" { $BuildNumberArray[0]++ }
        "minor" { $BuildNumberArray[1]++ }
        "build" { $BuildNumberArray[2]++ }
    }

    $versionedDestinationPath = Join-Path -Path $DestinationPath -ChildPath ('v{0}.{1}.{2}' -f $BuildNumberArray)

    # Create the versioned folder
    New-Item -ItemType Directory -Path $versionedDestinationPath

    # Copy the files
    $FilesToCopy | ForEach-Object {
        Copy-Item -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath -Recurse
    }
    $AdditionalFiles | ForEach-Object {
        Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath
    }
    $FoldersToCopy | ForEach-Object {
        Copy-Item -Recurse -Path (Join-Path -Path $SourcePath -ChildPath $_) -Destination $versionedDestinationPath
    }
    # If APIRA will parse info for apira build data and update the version number and write back to json file
    if ( $apiraBuild -eq $true) {
        $apira_build_data = Get-Content -Path "G:\devspace\projects\powershell\quicklog\apira_build_data.json" | ConvertFrom-Json
        $apira_build_data.Version = "v$BuildNumberArray" -replace " ", "."
        $apira_build_data | ConvertTo-Json | out-file -Path "G:\devspace\projects\powershell\quicklog\apira_build_data.json"
    }
}

 #Copy-BuildToVersionFolder -SourcePath G:\devspace\projects\powershell\quicklog -DestinationPath G:\devspace\projects\powershell\quicklog\dist -FilesToCopy @("quicklog.ps1") -FoldersToCopy @("libs") -IncrementVersion "build" -apira