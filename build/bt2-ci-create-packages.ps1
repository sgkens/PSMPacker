using module ..\..\NuPSForge\libs\New-NuspecPacakgeFile.psm1
using module ..\..\NuPSForge\libs\New-NupkgPacakge.psm1

# ? Powershell Gallery Description Does not support markdown indenting
# ? But Nuget and Choco Does
$Additional_descriptions = @"
PSMPacker is a helpful PowerShell utility module designed to assist in the build process of modules and script files.

 - Copy File(s) to destination
 - Exclude File(s) from copy
 - Create Nuspec File from Module Manifest
 - Export Nuspec File to .nupkg
 - Export Nuspec File to .zip
"@

# --Config--
$ModuleName = "psmpacker"
$ModuleManifest = Test-ModuleManifest -path .\dist\$ModuleName\$ModuleName.psd1

$NuSpecParams = @{
  path=".\dist\$ModuleName"
  ModuleName = $ModuleName
  ModuleVersion = $ModuleManifest.Version -replace "\.\d+$",""
  Author = $ModuleManifest.Author
  Description = "$($ModuleManifest.Description)"
  ProjectUrl = $ModuleManifest.PrivateData.PSData.ProjectUri
  License = "MIT"
  company = $ModuleManifest.CompanyName
  Tags = $ModuleManifest.Tags
  dependencies = $ModuleManifest.ExternalModuleDependencies
}
$NuSpecParamsChoco = @{
  path=".\dist\$ModuleName"
  ModuleName = $ModuleName
  ModuleVersion = $ModuleManifest.Version -replace "\.\d+$",""
  Author = $ModuleManifest.Author
  Description  = "$($ModuleManifest.Description)`n`n$Additional_descriptions"
  ProjectUrl = $ModuleManifest.PrivateData.PSData.ProjectUri
  License = "MIT"
  company = $ModuleManifest.CompanyName
  Tags = $ModuleManifest.Tags
  dependencies = $ModuleManifest.ExternalModuleDependencies
}
# --Config--

if(!(Test-Path -path .\dist\nuget)){mkdir .\dist\nuget}
if(!(Test-Path -path .\dist\choco)){mkdir .\dist\choco}
if(!(Test-Path -path .\dist\psgal)){mkdir .\dist\psgal}

# Create Zip With .nuspec file for PSGallery
write-host -foregroundColor Yellow "Creating Zip File for PSGallery"
$zipFileName = "$($NuSpecParams.ModuleName).zip"
compress-archive -path .\dist\$ModuleName\* -destinationpath .\dist\psgal\$zipFileName -compressionlevel optimal -update

New-NuspecPacakgeFile @NuSpecParams
Start-sleep -Seconds 1 # Wait for file to be created
New-NupkgPacakge -path .\dist\$ModuleName  -outpath .\dist\nuget

# Chocolatey Supports markdown in the description field so create a new nuspec file with additional descriptions in markdown
New-NuspecPacakgeFile @NuSpecParamsChoco
Start-sleep -Seconds 1 # Wait for file to be created
New-NupkgPacakge -path .\dist\$ModuleName  -outpath .\dist\choco


