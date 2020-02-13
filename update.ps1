if(!(Test-Path -Path '_gitView')){
    New-Item -ItemType Directory '_gitView'
    git clone 'remoteGit/content' '_gitView/content'
    git clone 'remoteGit/schema' '_gitView/schema'
    git clone 'remoteGit/target' '_gitView/website'
}

$currentLocation =  Get-Location;

Set-Location '_gitView/content'
git add .
git commit -m '...'
git push --tags
Set-Location $currentLocation

Set-Location '_gitView/schema'
git add .
git commit -m '...'
git push --tags
Set-Location $currentLocation

Set-Location '_gitView/website'
# delete local changes
git add .
git reset --hard
# get changes
git pull
Set-Location $currentLocation

