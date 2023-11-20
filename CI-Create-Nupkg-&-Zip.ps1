using module ..\NuPSForge\NuPSForge.psm1

# Powershell Gallery Description Does not support markdown indenting
# ? But Nuget and CHoc Does
$Additional_descriptions = @"
♦- Copy File(s) to destination
♦- Exclude File(s) from copy
♦- Create Nuspec File from Module Manifest
♦- Export Nuspec File to .nupkg
♦- Export Nuspec File to .zip

# Parameters
```powershell
Build-Module -SourcePath "path/to/module/folder" `
             -DestinationPath "path/to/output/folder" `
             -Name "pmpacker" `
             -IncrementVersion None `
             -FilesToCopy @("pmpacker.ps1", "license") `
             -FoldersToCopy @("libs") `
             -ScriptFile `
             -Version 0.2.0

```
"@

# --Config--
$ModuleManifest = Test-ModuleManifest -path .\dist\psmpacker\psmpacker.psd1

$NuSpecParams = @{
  path=".\dist\psmpacker"
  ModuleName = "psmpacker"
  ModuleVersion = $ModuleManifest.Version
  Author = $ModuleManifest.Author
  Description = "$($ModuleManifest.Description)`n`n$Additional_descriptions"
  ProjectUrl = $ModuleManifest.PrivateData.PSData.ProjectUri
  License = "MIT"
  company = $ModuleManifest.CompanyName
  Tags = $ModuleManifest.Tags
  dependencies = $ModuleManifest.ExternalModuleDependencies
}
# --Config--


New-NuspecPacakgeFile @NuSpecParams
Start-sleep -Seconds 3 # Wait for file to be created
New-NupkgPacakge -path .\dist\psmpacker  -outpath .\dist

# Create Zip With .nuspec file for PSGallery
$zipFileName = "$($NuSpecParams.ModuleName).$($ModuleManifest.Version.ToString()).zip"
compress-archive -path .\dist\psmpacker -destinationPath .\dist\$zipFileName -compressionlevel optimal


