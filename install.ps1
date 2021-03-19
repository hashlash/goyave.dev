param (
    [Parameter(Mandatory=$true)][string]$moduleName
)

$ErrorActionPreference = "Stop"

$projectName = [io.path]::GetFileNameWithoutExtension($moduleName)

if ( Test-Path -Path $projectName -PathType Container ) {
     Write-Error "$projectName already exists."
}

Write-Host "
  ,ad8888ba,                                                                  
 d8`"'    ```"8b                                                                 
d8'                                                                           
88              ,adPPYba,   8b       d8  ,adPPYYba,  8b       d8   ,adPPYba,  
88      88888  a8`"     `"8a  ``8b     d8'  `"`"     ``Y8  ``8b     d8'  a8P_____88  
Y8,        88  8b       d8   ``8b   d8'   ,adPPPPP88   ``8b   d8'   8PP`"`"`"`"`"`"`"  
 Y8a.    .a88  `"8a,   ,a8`"    ``8b,d8'    88,    ,88    ``8b,d8'    `"8b,   ,aa  
  ```"Y88888P`"    ```"YbbdP`"'       Y88'     ```"8bbdP`"Y8      `"8`"       ```"Ybbd8`"'  
                                d8'                                           
                               d8'
" -ForegroundColor cyan

Write-Host "------------------------------------------------------------------------------`n"

Write-Host "Thank you for using Goyave!" -Foreground green
Write-Host "If you like the framework, please consider supporting me on Github Sponsors or Patreon:"
Write-Host "https://github.com/sponsors/System-Glitch`n" -Foreground gray
Write-Host "https://www.patreon.com/bePatron?u=25997573`n" -Foreground gray

Write-Host "------------------------------------------------------------------------------`n"

Write-Host "Downloading template project..."
Invoke-WebRequest "https://github.com/go-goyave/template/archive/master.zip" -OutFile "temp.zip"

Write-Host "Unzipping..."
Expand-Archive -Path "temp.zip" -DestinationPath .
Remove-Item -Path "temp.zip"
Rename-Item template-master $projectName

Write-Host "Setup..."
$include = ("*.go","*.mod","*.json")
Get-ChildItem -Path $projectName -Include ("config.*.json") -Recurse | ForEach-Object  { 
    (Get-Content $_).Replace("goyave.dev/template", $projectName) | Set-Content $_
}
Get-ChildItem -Path $projectName -Include $include -Recurse | ForEach-Object  { 
    (Get-Content $_).Replace("goyave.dev/template", $moduleName) | Set-Content $_ 
}
Set-Location -Path $projectName
Copy-Item "config.example.json" -Destination "config.json"

Write-Host "Initializing git..."
git init > $null
git add . > $null
git commit -m "Init" > $null
Set-Location -Path ..

Write-Host "------------------------------------------------------------------------------`n"

Write-Host "Project setup successful!" -Foreground green
Write-Host "Happy coding!"