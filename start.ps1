param(
    [ValidateSet('Develop', 'Deploy')]
    [string]$Action
)

function Develop()
{
    # Update git submodules
    git submodule update --init

    # Run the hugo server
    hugo server -D -s blog
}

function Deploy()
{
    # Generate a new temporary directory for our deployment
    $deployDirectory = New-Item `
        -Path (Join-Path `
            ([System.IO.Path]::GetTempPath()) `
            ([System.IO.Path]::GetRandomFileName())) `
        -ItemType Directory

    # Determine the remote origin Git location
    $git_remote = git remote get-url --push origin

    # Update git submodules
    git submodule update --init

    # Build the site in the deploy directory
    hugo -s blog -d $deployDirectory

    # Initialise the deploy directory as a Git repository and add content
    Push-Location $deployDirectory

    # Create a new Git repository and add content
    git init
    git remote add origin "$git_remote"
    git checkout --orphan main
    git add .
    $datestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'
    git commit -m "Site updated at ${datestamp}"

    # Deploy code to the main branch
    git push --force origin main

    # Clean up the deploy directory
    Pop-Location
    Remove-Item -Path $deployDirectory -Recurse -Force

    # Display a success message
    $link = Format-Link -Url 'https://fgimian.github.io/'
    Write-Host "Deployment completed successfully!"
    Write-Host "Please pop over to ${link} to check out the updated site."
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Execute the required action
switch ($Action) {
    'Deploy' { Deploy }
    Default { Develop }
}
