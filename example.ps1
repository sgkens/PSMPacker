using module libs\New-BuildTVF.psm1
New-BuildTVF -SourcePath G:\devspace\projects\powershell\_repos\BuildTVF `
             -DestinationPath G:\devspace\projects\powershell\_repos\BuildTVF\dist `
             -Name "BuildTVF" `
             -IncrementVersion "build" `
             -FilesToCopy @("buildTVF.ps1","readme.md","license") `
             -FoldersToCopy @("libs") `
             -pssi



             # -apira
             # -psmm
             # -pssi