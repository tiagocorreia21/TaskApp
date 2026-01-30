#!/usr/bin/env pwsh
# Script simples para executar Backend e Frontend em paralelo
# Simple script to run Backend and Frontend in parallel

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TaskApp - Iniciando Aplicação        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Obter o diretório raiz do projeto
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Verificar se concurrently está instalado globalmente
$hasConcurrently = $null -ne (Get-Command concurrently -ErrorAction SilentlyContinue)

if (-not $hasConcurrently) {
    Write-Host "AVISO: 'concurrently' não está instalado globalmente" -ForegroundColor Yellow
    Write-Host "Instalando concurrently..." -ForegroundColor Yellow
    npm install -g concurrently
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
concurrently --names "BACKEND,FRONTEND" --prefix-colors "blue,green" "cd backend && npm start" "cd frontend && npm run dev"
