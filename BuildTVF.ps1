
<#PSScriptInfo

.VERSION 0.0.26.0

.GUID 19a4ba0b-0bb6-4ec7-98ed-4367089aa81d

.AUTHOR Snoonx

.COMPANYNAME Snoonx

.COPYRIGHT 2023 Snoonx. All rights reserved.

.TAGS automation, build, version, script, powershell, utility

.LICENSEURI https://choosealicense.com/licenses/mit

.PROJECTURI https://gitlab.snowlab.tk/powershell/BuildTVF.git

.ICONURI https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/logo.svg

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS .\libs\New-BuildTVF.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/Releases.md

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 BuildTVF or "Build To Version Folder" is a powershell utility module to help with the creation of versioned folders for software releases, mainly for use with GitLab CI/CD pipelines. Build for use with powershell modules and scriptfiles.

#> 
Param()

