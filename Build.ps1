param([Parameter(Mandatory=$true)]
      [int] $BuildNumber)

  $NuSpecPath = '.\Src\OnPublish.NuGet.nuspec'
  
  $NuSpecContent = gc $NuSpecPath 
  $NuSpecContent = $NuSpecContent -replace 'version\>(?<a>[0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+\<', "version>`${a}$BuildNumber<"
  sc $NuSpecPath $NuSpecContent

  md -Force -Name _Output
  del .\_Output\*.nupkg
  .\Lib\NuGet.exe pack "$NuSpecPath" -OutputDirectory ".\_Output"