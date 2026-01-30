#!/usr/bin/env pwsh
# Script de configuração inicial do projeto TaskApp
# Initial setup script for TaskApp project

param(
    [switch]$AutoInstallMongoDB = $false
)

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   TaskApp - Configuração Inicial      ║" -ForegroundColor Cyan
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
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

# Banner de boas-vindas
Write-Host "Este script irá:" -ForegroundColor Yellow
Write-Host "  ✓ Verificar pré-requisitos" -ForegroundColor Gray
Write-Host "  ✓ Executar deploy completo" -ForegroundColor Gray
Write-Host "  ✓ Preparar aplicação para uso" -ForegroundColor Gray
Write-Host ""

# Verificar Node.js
Write-Host "[1/5] Verificando Node.js..." -ForegroundColor Yellow
if (-not (Test-CommandExists "node")) {
    Write-Host "ERRO: Node.js não está instalado!" -ForegroundColor Red
    Write-Host ""
    exit 1
}

$nodeVersion = node --version
Write-Host "Node.js encontrado: $nodeVersion" -ForegroundColor Green

# Verificar npm
Write-Host "[2/5] Verificando npm..." -ForegroundColor Yellow
if (-not (Test-CommandExists "npm")) {
    Write-Host "ERRO: npm não está instalado!" -ForegroundColor Red
    exit 1
}

$npmVersion = npm --version
Write-Host "npm encontrado: v$npmVersion" -ForegroundColor Green


# Instalar dependências do root
Write-Host "[3/5] Instalando dependências globais do projeto..." -ForegroundColor Yellow
Set-Location $ProjectRoot
& $nodePath.Node $nodePath.Npm install --loglevel=error
if ($LASTEXITCODE -ne 0) {
    Write-Host "Aviso: Falha ao instalar dependências do root" -ForegroundColor Yellow
} else {
    Write-Host "Dependências globais instaladas!" -ForegroundColor Green
}

# Verificar/Instalar concurrently
Write-Host "[4/5] Verificando concurrently..." -ForegroundColor Yellow
$hasConcurrently = Test-CommandExists "concurrently"
if (-not $hasConcurrently) {
    # Tentar instalar globalmente
    Write-Host "Instalando concurrently globalmente..." -ForegroundColor Yellow
    & $nodePath.Node $nodePath.Npm install -g concurrently --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ concurrently instalado!" -ForegroundColor Green
    } else {
        Write-Host "concurrently não instalado globalmente (usará versão local)" -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ concurrently já está disponível" -ForegroundColor Green
}

# Executar deploy
Write-Host "[5/5] Executando deploy completo..." -ForegroundColor Yellow
Write-Host ""

if ($AutoInstallMongoDB) {
    & "$ProjectRoot\deploy.ps1" -AutoInstallMongoDB
} else {
    & "$ProjectRoot\deploy.ps1"
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Setup falhou durante o deploy!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}

# Voltar ao diretório original
Set-Location $OriginalLocation

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✓ Setup Concluído com Sucesso!      ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Para iniciar a aplicação, execute:" -ForegroundColor White
Write-Host "    .\start.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para mais informações, consulte:" -ForegroundColor Cyan
Write-Host "  • README.md" -ForegroundColor White
Write-Host ""

