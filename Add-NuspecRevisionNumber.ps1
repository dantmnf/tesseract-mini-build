param (
    [Parameter(Mandatory = $true)]
    [string]$infile,
    [Parameter(Mandatory = $true)]
    [string]$outfile
)
$revision = git rev-list --count --first-parent HEAD
$nuspec = [xml](Get-Content $infile)
$nuspec.package.metadata.version += "+r$revision"
$nuspec.Save($outfile)
