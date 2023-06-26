using module "G:\devspace\projects\powershell\_repos\Nuspecfile\libs\New-NupkgPacakge.psm1"

$scriptFileInfo = Test-ScriptFileInfo -path .\PSMPacker.ps1

$NuSpecParams = @{
  ModuleName = $scriptFileInfo.Name
  ModuleVersion = $scriptFileInfo.Version
  Author = $scriptFileInfo.Author
  Description = $scriptFileInfo.Description
  ProjectUrl = $scriptFileInfo.ProjectUrl
  License = $scriptFileInfo.License
  company = $scriptFileInfo.company
  Tags = $scriptFileInfo.Tags
  dependencies = $scriptFileInfo.ExternalModuleDependencies
}

New-NuspecPacakgeFile @NuSpecParams
New-NupkgPacakge -path .\dist  -outpath .\dist