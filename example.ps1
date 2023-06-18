using module libs\Build-Module.psm1
Build-Module -SourcePath G:\devspace\projects\powershell\_repos\BuildTVF `
             -DestinationPath G:\devspace\projects\powershell\_repos\BuildTVF\dist `
             -Name "PSMPacker" `
             -IncrementVersion None `
             -FilesToCopy @("PSMPacker.ps1","license") `
             -FoldersToCopy @("libs") `
             -ScriptFile `
             -Version 0.2.0



             # -apira
             # -psmm
             # -pssi