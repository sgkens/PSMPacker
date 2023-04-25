using module libs\Copy-BuildToVersionFolder.psm1
Copy-BuildToVersionFolder -SourcePath G:\devspace\projects\powershell\_repos\BuildTVF `
                          -DestinationPath G:\devspace\projects\powershell\_repos\BuildTVF\dist`
                          -FilesToCopy @("buildTVF.psm1","buildTVF.psd1","build.ps1","readme.md","license")`
                          -FoldersToCopy @("libs")`
                          -IncrementVersion "build"`
                          -name "BuildTVF"
                          #-apira