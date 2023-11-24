$ModuleName           = "commitfusion"
$ModuleManifest       = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
$SemVerVersion        = $ModuleManifest.Version -replace "\.\d+$",""


if(Get-command choco.exe){
  write-host "Chocolatey is installed, skipping install"
  write-host "Pushing to chocolatey https://community.chocolatey.org/"
  choco.exe push .\dist\$ModuleName.$SemVerVersion.nupkg --source https://community.chocolatey.org/
  write-host "Pushed to chocolatey - Complete"
}else{
  write-host "Chocolatey is not installed, please install chocolatey https://community.chocolatey.org/"
  break;
}