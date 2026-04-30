param(
    [Parameter(Mandatory = $true)]
    [string]$ImageUri,

    [Parameter(Mandatory = $false)]
    [string]$ManifestPath = "infra/k8s/aws/deployment.yaml"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ManifestPath)) {
    throw "Manifest not found: $ManifestPath"
}

$content = Get-Content $ManifestPath -Raw
if ($content -notmatch 'IMAGE_URI_PLACEHOLDER') {
    throw "Expected IMAGE_URI_PLACEHOLDER in $ManifestPath"
}

$content = $content -replace 'IMAGE_URI_PLACEHOLDER', $ImageUri
Set-Content -Path $ManifestPath -Value $content

Write-Host "Updated $ManifestPath with image: $ImageUri"