param($installPath, $toolsPath, $package, $project)

$projectName = $project.Name
$nuspecFileName = "$projectName.nuspec"
$nuspecTemplateFileName = 'nuspecTemplate.xml'

# $nuspecFile = $project.ProjectItems.Item("template.txt")
# $nuspecFile.Name = "$projectName.nuspec"

$projectPath = $project.FullName | Split-Path -Parent

# Make sure the $projectName.nuspec file exists
$nuspecPath = Join-Path $projectPath $nuspecFileName
if ((Test-Path $nuspecPath) -eq $false) 
{
  $currentExePath = Join-Path $installPath $nuspecTemplateFileName
  cp $currentExePath $nuspecPath
}

# Make sure the $projectName.nuspec is added to the solution
$projectItems = Get-Interface $project.ProjectItems ([EnvDTE.ProjectItems])
$nugetExe = $projectItems.GetEnumerator() | where { $_.Name -eq $nuspecFileName } | select -First 1
if ($nugetExe -eq $null) 
{
  $projectItems.AddFromFile($nuspecPath) 
}