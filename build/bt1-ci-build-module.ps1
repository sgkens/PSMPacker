using module ..\libs\Build-Module.psm1

Remove-Item -Path .\dist\psmpacker -Recurse -Force -ErrorAction SilentlyContinue

$AutoVersion = (Get-GitAutoVersion).Version

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name "psmpacker" `
             -IncrementVersion None `
             -FilesToCopy "psmpacker.psd1","license","psmpacker.psm1","icon.png" `
             -FoldersToCopy "libs" `
             -Manifest `
             -Dependencies @(@{type="module";name="quicklog";version="1.2.3"}) `
             -Version $AutoVersion