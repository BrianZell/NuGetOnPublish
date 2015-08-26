param($installPath, $toolsPath, $package)

$reloadRequired = $false
# Get the solution
$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

# Make sure the .nuget file folder exists
$solutionPath = $solution.FullName | Split-Path -Parent
$nugetPath = Join-Path $solutionPath '.nuget'
if ((Test-Path $nugetPath) -eq $false) 
{
  New-Item -Path $solutionPath -Name '.nuget' -ItemType 'directory' 
}

# Make sure the NuGet.exe file exists
$exePath = Join-Path $nugetPath 'NuGet.exe'
if ((Test-Path $exePath) -eq $false) 
{
  $currentExePath = Join-Path $installPath 'NuGet.exe'
  cp $currentExePath $exePath  
}

# Make sure the .nuget solution folder exists
$nugetProject = $solution.GetEnumerator() | where { $_.ProjectName -eq '.nuget' } | Select-Object -First 1
if ($nugetProject -eq $null) { $nugetProject = $solution.AddSolutionFolder('.nuget') }

# Make sure the NuGet.exe is added to the solution
$projectItems = Get-Interface $nugetProject.ProjectItems ([EnvDTE.ProjectItems])
$nugetExe = $projectItems.GetEnumerator() | where { $_.Name -eq 'NuGet.exe' } | Select-Object -First 1
if ($nugetExe -eq $null) 
{
    $projectItems.AddFromFile($exePath) 
}