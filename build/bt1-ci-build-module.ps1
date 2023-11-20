using module ..\libs\Build-Module.psm1
using module ..\libs\Get-GitAutoVersion.psm1

Remove-Item -Path .\dist\PSMPacker -Recurse -Force -ErrorAction SilentlyContinue
$AutoVersion = (Get-GitAutoVersion).Version

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name "PSMPacker" `
             -IncrementVersion None `
             -FilesToCopy "PSMPacker.psd1","license","PSMPacker.psm1","icon.png" `
             -FoldersToCopy "libs" `
             -Manifest `
             -Version $AutoVersion