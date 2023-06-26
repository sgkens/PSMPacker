using module .\libs\Build-Module.psm1
Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name "PSMPacker" `
             -IncrementVersion None `
             -FilesToCopy "PSMPacker.ps1","license","PSMPacker.psm1","icon.png" `
             -FoldersToCopy "libs" `
             -ScriptFile `
             -Version 0.1.0



<#
using module .\libs\Build-Module.psm1
Build-Module -SourcePath .\ `
-DestinationPath .\dist `
-Name "PSMPacker" `
-IncrementVersion None `
-FilesToCopy "PSMPacker.ps1","license" `
-FoldersToCopy "libs" `
-ExcludedFiles "logo.txt","libs/sm" `
-ScriptFile `
-Version 0.2.0


# -additionalfiles
# -apira
# -psmm
# -pssi
#>