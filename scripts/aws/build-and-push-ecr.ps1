param(
    [Parameter(Mandatory = $true)]
    [string]$AwsRegion,

    [Parameter(Mandatory = $false)]
    [string]$RepositoryName = "aceest-fitness",

    [Parameter(Mandatory = $false)]
    [string]$ImageTag = "v0.1.0"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    throw "AWS CLI is not installed or not available on PATH."
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker CLI is not installed or not available on PATH."
}

$accountId = aws sts get-caller-identity --query Account --output text
$registry = "$accountId.dkr.ecr.$AwsRegion.amazonaws.com"
$imageUri = "$registry/$RepositoryName`:$ImageTag"

aws ecr describe-repositories `
    --repository-names $RepositoryName `
    --region $AwsRegion *> $null

if ($LASTEXITCODE -ne 0) {
    aws ecr create-repository `
        --repository-name $RepositoryName `
        --region $AwsRegion *> $null
}

aws ecr get-login-password --region $AwsRegion |
    docker login --username AWS --password-stdin $registry

docker build -t "$RepositoryName`:$ImageTag" .
docker tag "$RepositoryName`:$ImageTag" $imageUri
docker push $imageUri

Write-Host "Pushed image: $imageUri"
