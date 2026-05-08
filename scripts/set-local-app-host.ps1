param(
    [Parameter(Mandatory = $true)]
    [string]$HostName
)

$ErrorActionPreference = 'Stop'

if ($HostName -notmatch '^[a-z0-9-]+\.localhost$') {
    throw "Usa un host valido nel formato nome.localhost."
}

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$srcRoot = Join-Path (Split-Path -Path $repoRoot -Parent) 'src'
$envPath = Join-Path $srcRoot '.env'
$certFile = Join-Path $repoRoot 'certs\\localhost.fullchain.crt'
$keyFile = Join-Path $repoRoot 'certs\\localhost.key'
$mkcert = 'C:\ProgramData\chocolatey\bin\mkcert.exe'

if (-not (Test-Path $mkcert)) {
    throw "mkcert non trovato in $mkcert."
}

$envContent = Get-Content -Raw $envPath
$updatedEnv = $envContent
$updatedEnv = [regex]::Replace($updatedEnv, '(?m)^APP_URL=.*$', "APP_URL=https://$HostName")
$updatedEnv = [regex]::Replace($updatedEnv, '(?m)^SECURITY_ALLOWED_ORIGINS=.*$', "SECURITY_ALLOWED_ORIGINS=https://$HostName")
$updatedEnv = [regex]::Replace($updatedEnv, '(?m)^WEBAUTHN_RP_ID=.*$', "WEBAUTHN_RP_ID=$HostName")
$updatedEnv = [regex]::Replace($updatedEnv, '(?m)^WEBAUTHN_ALLOWED_ORIGINS=.*$', "WEBAUTHN_ALLOWED_ORIGINS=https://$HostName")

Set-Content -Path $envPath -Value $updatedEnv -NoNewline

& $mkcert -cert-file $certFile -key-file $keyFile localhost $HostName 127.0.0.1 ::1 | Out-Host

docker compose -f (Join-Path $repoRoot 'compose.yaml') up -d --no-deps --force-recreate web | Out-Host

Write-Output "Host locale attivo: https://$HostName"
