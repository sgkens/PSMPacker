[![pongologo](./BuildTVF-logo.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/BuildTVF-logo.svg)
--
[![Maintainer](https://img.shields.io/badge/Maintainer-snoonx-blue??&stype=flat&logo=Personio&logoColor=blue)](https://gitlab.snowlab.tk/snoonx)
[![License](https://img.shields.io/gitlab/license/43?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk&logo=unlicense)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/LICENSE)
[![Latest Release](https://gitlab.snowlab.tk/powershell/BuildTVF/-/badges/release.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/releases) 
[![Pipeline Status](https://gitlab.snowlab.tk/powershell/BuildTVF/badges/main/pipeline.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/commits/main) 
[![Coverage Report](https://gitlab.snowlab.tk/powershell/BuildTVF/badgesmain/coverage.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/commits/main)
[![Contributors](https://img.shields.io/gitlab/contributors/powershell/BuildTVF?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk)](https://gitlab.snowlab.tk/powershell/BuildTVF/activity)

# PSMPacker
`pmpacker` is a PowerShell utility module designed to assist in the creation of versioned folders for PowerShell module and script projects. It provides functions to create versioned folders, update version numbers in module manifests and script files, copy files and folders to the destination folder, and perform additional operations such as creating Apira files or zip archives of the build folder.

Installation
To use pmpacker, follow these steps:

Clone the pmpacker repository to your local machine.
Import the module by running the following command: Import-Module path\to\pmpacker.psm1.
Usage
The main function provided by pmpacker is Build-Module. Here is an example of how to use it:

## Minimal Usage

```powershell
Build-Module -SourcePath "G:\devspace\projects\powershell\_repos\pmpacker" `
             -DestinationPath "G:\devspace\projects\powershell\_repos\pmpacker\dist" `
             -Name "pmpacker" `
             -IncrementVersion None `
             -FilesToCopy @("pmpacker.ps1", "license") `
             -FoldersToCopy @("libs") `
             -ScriptFile `
             -Version 0.2.0

```

The `Build-Module` function accepts the following parameters:


| Parameter | Type | Description  |
| -------- | -------- | -------- |
| SourcePath    | `[String]` ***`Req`***  | The path to the source folder.     |
|DestinationPath| `[String]` ***`Req`*** | The path to the destination folder.  |
|Name| `[String]` ***`Req`*** | The name of the module or script (same name as the source folder)  |
|IncrementVersion| `[String]` ***`Req`*** | The version number to increment. Valid values are "Major", "Minor", "Build", and "None". The default value is "Minor".  |
|FilesToCopy|`[String[]]` ***`opt`***|The files to copy to the destination folder.|