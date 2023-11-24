# Token Testing only
$COVERALLS_REPO_TOKEN="ASbN8fZ7M90NdUpU0wCgm3en0QMZbVlbb"

if(!(get-command coveralls)){
    throw [system.exception]::new("Unable to find converalls in $env:path")
    break;
}
coveralls.exe report --repo-token="$COVERALLS_REPO_TOKEN"