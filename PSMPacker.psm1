using module libs\Build-Module.psm1

$global:_psmpacker = @{
    rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

# ===============================================================
#  Module Exports
# ===============================================================
$members = @{
    function = @(
        "Build-Module"
    )
    alias    = @()
}

Export-ModuleMember @members


