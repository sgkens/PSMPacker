using module ..\propture\get-propture.ps1
Function Show-ASCIIArtProperties {
    Param(
        [string]$filePath
    )

    $properties = @{
        'Version' = '';
        'Author' = '';
        'DOC' = '';
    }

    # Read the file contents
    $fileContents = Get-Content -Path $filePath
    # Extract the properties from the file
    foreach ($line in $fileContents) {
        # explode content on line matching version - or auther - or DOCO
        if($line -like "-o *"){
            $proptureData = get-proptureSD -stringdata $line
            foreach ($prop in ($proptureData.Keys | sort-object name)){
                write-host -foregroundColor magenta "$($prop): " -nonewline; 
                #write-host -foregroundColor Yellow "{ " -nonewline; 
                write-host -foregroundColor Green "$($proptureData[$prop]) " -nonewline;
                #write-host -foregroundColor Yellow " }" -nonewline; 
               # write-host " "
            }
            write-host " "
        }
        else {
            write-host -foregroundColor white $line
        }
    }
}