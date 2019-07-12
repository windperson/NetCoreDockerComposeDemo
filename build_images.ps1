#!/usr/bin/env pwsh
# input parameter
[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(HelpMessage = "docker registry")]
    [String]$registry,
    [Parameter(HelpMessage = "frontend version")]
    [String]$frontendVer,
    [Parameter(HelpMessage = "backend version")]
    [String]$backendVer,
    [Parameter(HelpMessage = "Use timestamp for image tag")]
    [switch]$useTimeStamp = $false,
    [Parameter(HelpMessage = "Push images to repository")]
    [switch]$pushImgs = $false,
    [Parameter(ValueFromRemainingArguments)]
    [String]$other_args
)

$timeStamp = (Get-Date).ToUniversalTime().ToString("yyyyMMdd-HHmmss");

if ($registry) {
  $env:DOCKER_REGISTRY = $registry + "/";
  Write-Output "Using Registry= `"$env:DOCKER_REGISTRY`""
}

if ($frontendVer) {
  $env:FRONTEND_VER = $frontendVer;
  Write-Output "Use Frontend Version= $env:FRONTEND_VER"
} elseif ($useTimeStamp) {
  $env:FRONTEND_VER = $timeStamp;
  Write-Output "Use Frontend Version= $env:FRONTEND_VER"
}

if ($backendVer) {
  $env:BACKEND_VER = $backendVer;
  Write-Output "Use Backend Version= $env:BACKEND_VER"
} elseif ($useTimeStamp) {
  $env:BACKEND_VER = $backendVer;
  Write-Output "Use Backend Version= $env:BACKEND_VER"
}

docker-compose -f docker-compose.yml build $other_args

if ($pushImgs -and $registry) {
  Write-Output "Push images to `"$registry`""
  docker images "$registry/*" --format "{{.Repository}}" | Select-Object -Unique | ForEach-Object { docker push $_ }
}

if ($env:DOCKER_REGISTRY) {
  Remove-Item Env:\DOCKER_REGISTRY;
}
if ($env:FRONTEND_VER) {
  Remove-Item Env:\FRONTEND_VER
}
if ($env:BACKEND_VER) {
  Remove-Item Env:\BACKEND_VER
}
