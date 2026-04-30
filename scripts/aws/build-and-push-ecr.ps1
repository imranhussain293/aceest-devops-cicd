param(
    [Parameter(Mandatory = $true)]
    [string]$AwsRegion,

    [Parameter(Mandatory = $false)]
    [string]$RepositoryName = "aceest-fitness",

    [Parameter(Mandatory = $false)]
    [string]$ImageTag = "v0.1.0"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker CLI is not installed or not available on PATH."
}

function Invoke-Aws {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$AwsArgs
    )

    $localAws = Get-Command aws -ErrorAction SilentlyContinue
    if ($localAws) {
        & $localAws.Source @AwsArgs
        return
    }

    $awsDir = Join-Path $env:USERPROFILE ".aws"
    if (-not (Test-Path $awsDir)) {
        throw "AWS CLI is not installed and $awsDir does not exist. Configure AWS credentials first."
    }

    docker run --rm `
        -v "$awsDir`:/root/.aws" `
        amazon/aws-cli @AwsArgs
}

$accountId = Invoke-Aws sts get-caller-identity --query Account --output text
$registry = "$accountId.dkr.ecr.$AwsRegion.amazonaws.com"
$imageUri = "$registry/$RepositoryName`:$ImageTag"

$repoExists = $true
Invoke-Aws ecr describe-repositories `
    --repository-names $RepositoryName `
    --region $AwsRegion *> $null

if ($LASTEXITCODE -ne 0) {
    $repoExists = $false
}

if (-not $repoExists) {
    Invoke-Aws ecr create-repository `
        --repository-name $RepositoryName `
        --region $AwsRegion *> $null
}

Invoke-Aws ecr get-login-password --region $AwsRegion |
    docker login --username AWS --password-stdin $registry

docker build -t "$RepositoryName`:$ImageTag" .
docker tag "$RepositoryName`:$ImageTag" $imageUri
docker push $imageUri

Write-Host "Pushed image: $imageUri"
