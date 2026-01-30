#!/usr/bin/env pwsh
# Script simples para executar Backend e Frontend em paralelo
# Simple script to run Backend and Frontend in parallel

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TaskApp - Iniciando Aplicação        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Obter o diretório raiz do projeto
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Função para obter o caminho do Node.js (sistema ou local)
function Get-NodePath {
    $localNodePath = Join-Path $ProjectRoot "nodejs-local"
    $nodeExe = Get-ChildItem -Path $localNodePath -Filter "node.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($nodeExe) {
        return @{
            Node = $nodeExe.FullName
            Npm = (Get-ChildItem -Path $localNodePath -Filter "npm.cmd" -Recurse | Select-Object -First 1).FullName
            IsLocal = $true
        }
    } elseif ($null -ne (Get-Command node -ErrorAction SilentlyContinue)) {
        return @{
            Node = "node"
            Npm = "npm"
            IsLocal = $false
        }
    }

    return $null
}

# Verificar Node.js
$nodePath = Get-NodePath
if (-not $nodePath) {
    Write-Host "ERRO: Node.js não está instalado!" -ForegroundColor Red
    Write-Host "Execute primeiro: .\setup.ps1" -ForegroundColor Yellow
    exit 1
}

# Verificar se concurrently está instalado globalmente
$hasConcurrently = $null -ne (Get-Command concurrently -ErrorAction SilentlyContinue)

if (-not $hasConcurrently) {
    Write-Host "AVISO: 'concurrently' não está instalado globalmente" -ForegroundColor Yellow
    Write-Host "Instalando concurrently..." -ForegroundColor Yellow
    if ($nodePath.IsLocal) {
        & $nodePath.Node $nodePath.Npm install -g concurrently
    } else {
        npm install -g concurrently
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Falha ao instalar concurrently!" -ForegroundColor Red
        Write-Host "Como alternativa, use: .\run.ps1" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Backend: http://localhost:4000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pressione Ctrl+C para parar os servidores" -ForegroundColor Yellow
Write-Host ""

# Executar ambos com concurrently
Set-Location $ProjectRoot
if ($nodePath.IsLocal) {
    # Usar Node.js local
    & $nodePath.Node $nodePath.Npm run dev
} else {
    # Usar npm do sistema
    npm run dev
}
