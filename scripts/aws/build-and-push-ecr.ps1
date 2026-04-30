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

    $awsCliV2 = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
    if (Test-Path $awsCliV2) {
        & $awsCliV2 @AwsArgs
        return
    }

    $localAws = Get-Command aws.exe -ErrorAction SilentlyContinue
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

$previousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$describeOutput = Invoke-Aws ecr describe-repositories `
    --repository-names $RepositoryName `
    --region $AwsRegion 2>&1
$describeExitCode = $LASTEXITCODE
$ErrorActionPreference = $previousErrorActionPreference

$repoExists = $true
if ($describeExitCode -ne 0 -and ($describeOutput -match "RepositoryNotFoundException")) {
    $repoExists = $false
} elseif ($describeExitCode -ne 0) {
    throw $describeOutput
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
