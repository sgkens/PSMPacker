
<#PSScriptInfo

.VERSION 0.1.0.0

.GUID 19a4ba0b-0bb6-4ec7-98ed-4367089aa81d

.AUTHOR G k. Snow

.COMPANYNAME kenspsstack

.COPYRIGHT 2023 G k. Snow. All rights reserved.

.TAGS automation, build, version, script, powershell, utility

.LICENSEURI https://choosealicense.com/licenses/mit

.PROJECTURI https://github.com/gkens/PSMPacker

.ICONURI https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/logo.svg

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS .\libs\Build-Moule.psm1, .\libs\sm\format-inco.psm1, .\libs\sm\show-ASCIIArtProperties.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/Releases.md

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
    PSMPacker is a helpful PowerShell utility module designed to assist in the build process of modules and script files. It offers users the flexibility to select and exclude specific files from the source build folder, resulting in an output of either the "ModuleName" folder or the "ModuleName_v{0}.{0}.{0}" folder.
#> 
Param()


