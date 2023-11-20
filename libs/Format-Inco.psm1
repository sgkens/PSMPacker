
<#PSScriptInfo

.VERSION 0.1.1

.GUID 861e048c-bdc0-4c5d-acf3-f4169d5b3efa

.AUTHOR snoonx / snoonx

.COMPANYNAME snoonx

.COPYRIGHT 2023 snoonx. All rights reserved.

.TAGS colored, text, console, object

.LICENSEURI https://choosealicense.com/licenses/mit

.PROJECTURI https://gitlab.snowlab.tk/powershell/mailisearchps.git

.ICONURI https://gitlab.snowlab.tk/powershell/mailisearchps/-/blob/main/logo.svg

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
https://gitlab.snowlab.tk/powershell/mailisearchps/-/blob/main/Releases.md

.PRIVATEDATA
{
    PSData = @{
        PSData = @{
            Tags = 'colored, text, console, object'
        }
    }
}
#> 
<# 
.DESCRIPTION 
Function to generate an return inline colorized text, can be used in 'write-host' and directly in [object] output to console
#> 
Function Format-Inco {
    [CmdletBinding()]
    [alias("inco")]
    [OutputType([string])]
    param(

        
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )][Alias("s")][string]  $string,
        [Parameter(
            Mandatory = $false,
            Position = 1
        )][Validateset(
            "Red", 
            "Green", 
            "Yellow", 
            "Blue", 
            "Magenta", 
            "Cyan", 
            "DarkRed",
            "DarkGreen", 
            "DarkYellow", 
            "DarkCyan",
            "DarkMagenta",
            "DarkBlue",
            "DarkGrey",
            "Grey",
            "White",
            "Black",
            ignorecase=$true
        )][Alias("c")][string] $color,
        [Parameter(
            Mandatory = $false,
            Position = 2
        )][Validateset(
            "Red", 
            "Green", 
            "Yellow", 
            "Blue", 
            "Magenta", 
            "Cyan", 
            "DarkRed",
            "DarkGreen", 
            "DarkYellow", 
            "DarkCyan",
            "DarkMagenta",
            "DarkBlue",
            "DarkGrey",
            "Grey",
            "White",
            "Black",
            ignorecase=$true
        )][Alias("b")][string] $bcolor = ""
    )

    BEGIN {
        $OutputString = ""
    }

    PROCESS {
        switch ($color) {
            "white" {
                $OutputString = "`e[97m$string"
            }
            "black" {
                $OutputString = "`e[30m$string"
            }
            "grey" {
                $OutputString = "`e[90m$string"
            }
            "darkgrey" {
                $OutputString = "`e[90m$string"
            }
            "Red" {
                $OutputString = "`e[31m$string"
            }
            "Green" {
                $OutputString = "`e[32m$string"
            }
            "Yellow" {
                $OutputString = "`e[33m$string"
            }
            "Blue" {
                $OutputString = "`e[34m$string"
            }
            "Magenta" {
                $OutputString = "`e[35m$string"
            }
            "Cyan" {
                $OutputString = "`e[36m$string"
            }
            "darkRed" {
                $OutputString = "`e[91m$string"
            }
            "DarkGreen" {
                $OutputString = "`e[92m$string"
            }
            "DarkYellow" {
                $OutputString = "`e[93m$string"
            }
            "DarkCyan" {
                $OutputString = "`e[96m$string"
            }
            "DarkMagenta" {
                $OutputString = "`e[95m$string"
            }
            "DarkBlue" {
                $OutputString = "`e[94m$string"
            }
            Default {
                $OutputString = "`e[97m$string"
            }
        }
        switch ($bcolor) {
            "Red" {
                $OutputString += "`e[31m"
            }
            "Green" {
                $OutputString += "`e[32m"
            }
            "Yellow" {
                $OutputString += "`e[33m"
            }
            "Blue" {
                $OutputString += "`e[34m"
            }
            "Magenta" {
                $OutputString += "`e[35m"
            }
            "Cyan" {
                $OutputString += "`e[36m"
            }
            "darkRed" {
                $OutputString += "`e[91m"
            }
            "DarkGreen" {
                $OutputString += "`e[92m"
            }
            "DarkYellow" {
                $OutputString += "`e[93m"
            }
            "DarkCyan" {
                $OutputString += "`e[96m"
            }
            "DarkMagenta" {
                $OutputString += "`e[95m"
            }
            "DarkBlue" {
                $OutputString += "`e[94m"
            }
            "DarkGrey" {
                $OutputString += "`e[90m"
            }
            "Grey" {
                $OutputString += "`e[37m"
            }
            "White" {
                $OutputString += "`e[97m"
            }
            "Black" {
                $OutputString += "`e[30m"
            }
            Default {
                $OutputString += "`e[0m"
            }
        }
    }
    END {
        return $OutputString
    }
}
Export-ModuleMember -Function Format-Inco

