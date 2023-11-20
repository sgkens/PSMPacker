#using module ..\NuPSForge\libs\New-NupkgPacakge.psm1
using module ..\NuPSForge\libs\New-NuspecPacakge.psm1

# $scriptFileInfo = Test-ScriptFileInfo -path .\logtastic.psd1

# $NuSpecParams = @{
#   ModuleName = $scriptFileInfo.Name
#   ModuleVersion = $scriptFileInfo.Version
#   Author = $scriptFileInfo.Author
#   Description = $scriptFileInfo.Description
#   ProjectUrl = $scriptFileInfo.ProjectUrl
#   License = $scriptFileInfo.License
#   company = $scriptFileInfo.company
#   Tags = $scriptFileInfo.Tags
#   dependencies = $scriptFileInfo.ExternalModuleDependencies
# }

# New-NuspecPacakgeFile @NuSpecParams
# New-NupkgPacakge -path .\dist\PSMPacker  -outpath .\dist