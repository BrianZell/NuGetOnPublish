param()

$ErrorActionPreference='Stop';

trap
{
  write-output $_
  [Environment]::Exit(1)
}

.\Deploy\NuGet.exe push .\*.nupkg