param (
    [Parameter(Mandatory = $true)]
    [string]$infile,
    [Parameter(Mandatory = $true)]
    [string]$outfile
)
$revision = git rev-list --count --first-parent HEAD
$nuspec = [xml](Get-Content $infile)
$nuspec.package.metadata.version += ".$revision"
$nuspec.package.metadata.repository.branch = git rev-parse --abbrev-ref HEAD
$nuspec.package.metadata.repository.commit = git rev-parse --verify HEAD
$nuspec.Save($outfile)
