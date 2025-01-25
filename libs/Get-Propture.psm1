function Get-ProptureSD(){
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [parameter(mandatory=$true)]
        [string]$stringdata
    )
    $stringdata= $stringdata -replace "\\", "/"
    $formatted_stringdata = $stringdata -replace ','," `n "
    $hashedtdata = ConvertFrom-StringData -StringData $formatted_stringdata
    return $hashedtdata

}
$exports = @{
    function = @('Get-ProptureSD')
}
export-modulemember @exports

#$pt = get-propture -stringdata "my log messhae > @{pt:{Name=myfIle.html,size=100mb}} afsf isfisfas a console log messaage exablee @{pt:{prop1=myprob,prop2=mypoprb2}}"
#$pt
# get-proptureSD -stringdata "Name=G:\users\gsnow,size=100"