<div align="center">
    <a href="https://github.com/othneildrew/Best-README-Template">
        <img src="https://raw.githubusercontent.com/phellams/phellams-general-resources/refs/heads/main/logos/psmpacker/psmpacker-logo-base.svg" alt="Logo" width="80" height="80">
    </a>
    </br>
    <span style="font-size: 36px; font-weight: bold;">PSMPacker</span>
    </br>
    <img src="https://img.shields.io/badge/MIT-License-blue" alt="MIT License" />
    <p><b>PowerShell</b> utility module designed to assist in the creation of versioned folders for PowerShell module and script projects. It provides functions to create versioned folders, update version numbers in module manifests and script files, copy files and folders to the destination folder, and create zip archives of the build folder.</p>
</div>

### 🔹 Features

 - Copy and or exclude files and folders to the destination folder
 - Create zip archive of the build folder
 - Update the version number in the module manifest and script file
 - Increment the version number in the module manifest and script file



<!-- ABOUT THE PROJECT -->
### 🔹 About The Project

> I wanted a simple solution to copy and/or exclude files and folders from a source folder to a destination folder, and then update the version number in the module manifest and script file, check modile config with test-modulemanifest.
> 
> I also wanted to be able to increment the version number in the module manifest and script files, and rename the .version inside the module manifest .psd1 and PSScriptFileInfo .ps1 files for automated builds using **commitfusions** `get-gitautoversion` function to get the version number from the git repository.
> 
> **PSMpacker** is meant to use in conjunction with **CSVerify** and **NuPsForge** to build and publish PowerShell modules and scripts compatable with the **PowerShell Gallery**, **Chocolatey**, **gitlab(CE|EE)** Nuget Repositories, and **Proget** Powershell Nuget Repositories via the pipeline.

<!-- INSTALLATION -->
### 🔹 Installing module 

#### Clone
1. Clone the `pmpacker` repository to your local machine.
2. Import the module by running the following command:
```powershell
git clone https://github.com/phellams/pmpacker.git
cd pmpacker
Import-Module .\
```

#### PSGallery

```powershell
Find-Module -Name pmpacker -Repository PSGallery | Install-Module
```

#### Releases or Tags

##### Github
Download the latest release from the [**⏬Releases**](https://github.com/phellams/pmpacker/releases) or [**⏬Tags**](https://github.com/phellams/pmpacker/tags) page.

PowerShell `CLI`:
```powershell
iwr -Uri https://github.com/phellams/pmpacker/releases/latest/download/pmpacker.zip -OutFile pmpacker.zip
Expand-Archive -Path pmpacker.zip -DestinationPath pmpacker
import-module .\pmpacker
```
##### Gitlab
Download the latest tag from the [**⏬Releases**](https://gitlab.com/sgkens/pmpacker/-/releases) page or [**⏬Tags**](https://gitlab.com/sgkens/pmpacker/-/tags) page.

PowerShell `CLI`:
```powershell
iwr -Uri https://gitlab.com/sgkens/pmpacker/-/archive/main/pmpacker-main.zip -OutFile pmpacker.zip
Expand-Archive -Path pmpacker.zip -DestinationPath pmpacker
import-module .\pmpacker
```


### 🔹 Parameters

The `Build-Module` function accepts the following parameters:

 - `-SourcePath`: The path to the source folder.
 - `-DestinationPath`: The path to the destination folder.
 - `-Name`: The name of the module or script (same name as the source folder).
 - `-IncrementVersion`(`🚧WIP`): The version number to increment. Valid values are "Major", "Minor", "Build", and "None". The default value is "Minor", logic for this is still being worked on.
 - `-FilesToCopy`: The files to copy to the destination folder.
 - `-FoldersToCopy`: The folders to copy to the destination folder.
 - `-Manifest`: Rename the .VERSION inside the Module Manifest .psd1 file.
 - `-ZipArchive`: Create a zip archive of the build folder.
 - `-Dependencies`: An array of hashtables containing module dependencies.
 - `-Version`: The version number to use.
 - `-ScriptFile`: Rename the .VERSION inside the PSScriptFileInfo .ps1 file.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 🔹 Minimal Usage
Copy  files and folders to the destination folder incrementing the version number

```powershell
Build-Module -SourcePath "path\to\source" `
             -DestinationPath "path\to\dist" `
             -Name "pmpacker", `
             -IncrementVersion minor
```

### 🔹 Usage
Copy files and folders to the destination folder excluding notes.txt
```powershell
Build-Module -SourcePath "path\to\source" `
             -DestinationPath "path\to\dist" `
             -Name "pmpacker" `
             -IncrementVersion None ` # default minor use none when specifing a version number
             -FilesToCopy @("pmpacker.ps1", "license") `
             -FoldersToCopy @("libs") `
             -ExcludeFiles @("notes.txt") `
             -Manifest ` # Rename the .VERSION inside the Module Manifest .psd1 file
             -Version 0.2.0 # The version number to use
```

Exclude files and add dependencies check
```powershell
Build-Module -SourcePath "path\to\source" `
             -DestinationPath "path\to\dist" `
             -Name "pmpacker" `
             -IncrementVersion None ` # default minor use none when specifing a version number
             -FilesToCopy @("pmpacker.ps1", "license") `
             -FoldersToCopy @("libs") `
             -ExcludeFiles @("notes.txt") `
             -Manifest ` # Rename the .VERSION inside the Module Manifest .psd1 file
             -Version 0.2.0 # The version number to use
             -Dependencies @(@{type="module";name="quicklog";version="1.2.3"}) `
```

> **Note!** 🦜
> `Test-ModuleManifest` is used to validate module manifest because it runs each time in a session it will fail if the module is not available in one of the default module root paths `$env:PSModulePath` . 

> **Note!** 🦜
> Make sure dependant modules in `RequiredModules = @()` in the module manifest `.psd1` are available in one of the default module root paths `$env:PSModulePath` before running `Build-Module`, and reference them in the module manifest `.psd1` using `@{type="module";name="quicklog";version="1.2.3"}`, psmpacker will check and fail if the module is not available in one of the default module root paths `$env:PSModulePath`.

> **Note!** 🦜
> build-Module will still build even build but if you are running this on a CI/CD pipeline it will fail.

## 🔻 Roadmap
🟡 Work in Progress
 - [ ] Configure Devops for gitlab SE and psgallary deployment
 - [ ] Creating unit test using pester 5.5
 - [ ] Test IncrementVersion "Major", "Minor", "Build"
 - [ ] Clean up and commit code
 - [ ] Make log output a consistant format


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
### License

Distributed under the MIT License. See `LICENSE` for more information.

