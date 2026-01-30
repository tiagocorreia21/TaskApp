#!/usr/bin/env pwsh
# Script para fazer deploy da aplicação (Backend + Frontend)
# Deploy script for the application (Backend + Frontend)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploy TaskApp - Backend + Frontend  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

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

Write-Host "✓ Node.js encontrado: $(node --version)" -ForegroundColor Green
Write-Host "✓ npm encontrado: $(npm --version)" -ForegroundColor Green
Write-Host ""

# Obter o diretório raiz do projeto
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
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
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao instalar dependências do backend!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependências do backend instaladas com sucesso!" -ForegroundColor Green
Write-Host ""

Write-Host "Compilando TypeScript do backend..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao compilar o backend!" -ForegroundColor Red
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
    exit 1
}

Set-Location $FrontendPath
Write-Host "Instalando dependências do frontend..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao instalar dependências do frontend!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependências do frontend instaladas com sucesso!" -ForegroundColor Green
Write-Host ""

Write-Host "Compilando frontend para produção..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao compilar o frontend!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Frontend compilado com sucesso!" -ForegroundColor Green
Write-Host ""

# Voltar ao diretório raiz
Set-Location $ProjectRoot

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Deploy concluído com sucesso!        " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para executar a aplicação, use: .\run.ps1" -ForegroundColor Cyan
Write-Host ""
