#!/usr/bin/env pwsh
# Script para fazer deploy da aplicação (Backend + Frontend)
# Deploy script for the application (Backend + Frontend)

param(
    [switch]$AutoInstallMongoDB = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploy TaskApp - Backend + Frontend  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# Obter o diretório raiz do projeto e salvar diretório atual
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalLocation = Get-Location

# Função para verificar se um comando existe
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Verificar se Node.js está instalado
Write-Host "Verificando pré-requisitos..." -ForegroundColor Yellow
if (-not (Test-CommandExists "node")) {
    Write-Host "ERRO: Node.js não está instalado!" -ForegroundColor Red
    Write-Host "Por favor, instale Node.js de https://nodejs.org/" -ForegroundColor Red
    exit 1
}

if (-not (Test-CommandExists "npm")) {
    Write-Host "ERRO: npm não está instalado!" -ForegroundColor Red
    exit 1
}

$nodeVersion = node --version
$npmVersion = npm --version
Write-Host "✓ Node.js encontrado: $nodeVersion" -ForegroundColor Green
Write-Host "✓ npm encontrado: $npmVersion" -ForegroundColor Green
Write-Host ""

# Obter o caminho do Node.js e adicionar ao PATH para garantir que cmd.exe encontre
$nodePath = (Get-Command node).Source
$nodeDir = Split-Path -Parent $nodePath
Write-Host "Configurando PATH do Node.js: $nodeDir" -ForegroundColor Yellow
$env:PATH = "$nodeDir;$env:PATH"
Write-Host ""

$BackendPath = Join-Path $ProjectRoot "backend"
$FrontendPath = Join-Path $ProjectRoot "frontend"

# Deploy do Backend
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  1/2 - Deploy do Backend              " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BackendPath)) {
    Write-Host "ERRO: Diretório backend não encontrado!" -ForegroundColor Red
    exit 1
}

Set-Location $BackendPath
Write-Host "Instalando dependências do backend..." -ForegroundColor Yellow
if ($nodePath.IsLocal) {
    & $nodePath.Node $nodePath.Npm install
} else {
    npm install
}
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao instalar dependências do backend!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}
Write-Host "Dependências do backend instaladas com sucesso!" -ForegroundColor Green
Write-Host ""

# Verificar e preparar MongoDB Memory Server
Write-Host "Verificando MongoDB Memory Server..." -ForegroundColor Yellow
$mongodbBinariesPath = Join-Path $BackendPath "mongodb-binaries"

# Criar diretório se não existir
if (-not (Test-Path $mongodbBinariesPath)) {
    Write-Host "  Criando diretório para binários do MongoDB..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $mongodbBinariesPath -Force | Out-Null
}

# Verificar se já existe binário do MongoDB
$mongoExe = Get-ChildItem -Path $mongodbBinariesPath -Filter "mongod-*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($mongoExe) {
    Write-Host "MongoDB binário encontrado: $($mongoExe.Name)" -ForegroundColor Green
} else {
    Write-Host "  MongoDB binário não encontrado!" -ForegroundColor Yellow

    $shouldInstall = $false

    if ($AutoInstallMongoDB) {
        Write-Host "  Modo automático: instalando MongoDB..." -ForegroundColor Cyan
        $shouldInstall = $true
    } else {
        Write-Host "  Deseja baixar o MongoDB agora? (Recomendado)" -ForegroundColor Yellow
        Write-Host "  (Isso pode demorar alguns minutos na primeira vez)" -ForegroundColor Gray
        Write-Host ""

        $response = Read-Host "Baixar MongoDB agora? (S/n)"
        $shouldInstall = ($response -ne 'n' -and $response -ne 'N')
    }

    if ($shouldInstall) {
        Write-Host ""
        Write-Host "  Iniciando download do MongoDB..." -ForegroundColor Cyan

        # Executar script de instalação do MongoDB
        $installMongoScript = Join-Path $ProjectRoot "install-mongodb.ps1"
        if (Test-Path $installMongoScript) {
            & $installMongoScript
            if ($LASTEXITCODE -ne 0) {
                Write-Host "⚠ Aviso: Falha ao baixar MongoDB" -ForegroundColor Yellow
                Write-Host "  A aplicação tentará baixar automaticamente na primeira execução" -ForegroundColor Gray
            }
        } else {
            Write-Host "Script install-mongodb.ps1 não encontrado" -ForegroundColor Yellow
            Write-Host "  O MongoDB será baixado automaticamente na primeira execução" -ForegroundColor Gray
        }
    } else {
        Write-Host "  MongoDB será baixado automaticamente na primeira execução..." -ForegroundColor Gray
    }
}

Write-Host ""

Write-Host "Compilando TypeScript do backend..." -ForegroundColor Yellow
if ($nodePath.IsLocal) {
    & $nodePath.Node $nodePath.Npm run build
} else {
    npm run build
}
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao compilar o backend!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}
Write-Host "✓ Backend compilado com sucesso!" -ForegroundColor Green
Write-Host ""

# Deploy do Frontend
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  2/2 - Deploy do Frontend             " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $FrontendPath)) {
    Write-Host "ERRO: Diretório frontend não encontrado!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}

Set-Location $FrontendPath
Write-Host "Instalando dependências do frontend..." -ForegroundColor Yellow
if ($nodePath.IsLocal) {
    & $nodePath.Node $nodePath.Npm install
} else {
    npm install
}
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao instalar dependências do frontend!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}
Write-Host "Dependências do frontend instaladas com sucesso!" -ForegroundColor Green
Write-Host ""

Write-Host "Compilando frontend..." -ForegroundColor Yellow
if ($nodePath.IsLocal) {
    & $nodePath.Node $nodePath.Npm run build
} else {
    npm run build
}
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao compilar o frontend!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}
Write-Host "✓ Frontend compilado com sucesso!" -ForegroundColor Green
Write-Host ""

# Voltar ao diretório original
Set-Location $OriginalLocation

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Deploy concluído com sucesso!        " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
