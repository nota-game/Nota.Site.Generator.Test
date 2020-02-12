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

# delete all but recent commit
$hash = (git rev-parse HEAD) | Out-String
$hash = $hash.Substring(0,'9a534287cd02db3bf1522bdde0766eb2853bdb6d'.Length)
Write-Information "Remove every thing but commit $hash"

$date = Get-Date;

git checkout --force --orphan temp $hash      # checkout to the status of the git repo at commit f; creating a branch named "temp"
git commit -m "new root commit $date"     # create a new commit that is to be the new root commit
git rebase --onto temp $hash master   # now rebase the part of history from <f> to master onthe temp branch
git branch -D temp                  # we don't need the temp branch anymore

git gc --prune=all

git push --force

Set-Location $currentLocation

# delete old no longer needed History.
Set-Location 'remoteGit/target'
git gc --prune=all
Set-Location $currentLocation