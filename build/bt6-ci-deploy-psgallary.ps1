  # puish to proget pscore repo 'powershell gallery'
  # Publish-Module -Path ".\dist\$zipFileName" -Repository pscore -NuGetApiKey $apikey
  $modulename = "commitfusion"
  $ModuleManifest = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
  publish-Module `
    -path ".\dist\$modulename" `
    -Repository $ProGet_PSGalInstance `
    -NuGetApiKey $apikey `
    -projecturi $ModuleManifest.ProjectUri `
    -licenseuri $ModuleManifest.LicenseUri `
    -IconUri 'https://gitlab.snowlab.tk/sgkens/resources/-/blob/raw/modules/CommitFusion/dist/v1/ccommits-logo_GitIcon_51.20dpi.png' `
    -ReleaseNotes $ModuleManifest.ReleaseNotes `
    -Tags $ModuleManifest.Tags `
    -Verbose