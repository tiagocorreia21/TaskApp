#!/usr/bin/env pwsh
# Script para executar a aplicação completa (Backend + Frontend)
# Run script for the complete application (Backend + Frontend)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Executar TaskApp - Backend + Frontend" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "SilentlyContinue"

# Obter o diretório raiz do projeto
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackendPath = Join-Path $ProjectRoot "backend"
$FrontendPath = Join-Path $ProjectRoot "frontend"

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
Write-Host "Verificando Node.js..." -ForegroundColor Yellow
$nodePath = Get-NodePath

if (-not $nodePath) {
    Write-Host "ERRO: Node.js não está instalado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, execute primeiro o setup:" -ForegroundColor Yellow
    Write-Host "  .\setup.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

if ($nodePath.IsLocal) {
    Write-Host "✓ Usando Node.js local" -ForegroundColor Green
} else {
    Write-Host "✓ Usando Node.js do sistema" -ForegroundColor Green
}
Write-Host ""

# Verificar se as dependências foram instaladas
if (-not (Test-Path (Join-Path $BackendPath "node_modules"))) {
    Write-Host "AVISO: Dependências do backend não instaladas!" -ForegroundColor Yellow
    Write-Host "Execute primeiro: .\deploy.ps1" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Deseja executar o deploy agora? (S/N)"
    if ($response -eq "S" -or $response -eq "s") {
        & "$ProjectRoot\deploy.ps1"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERRO: Deploy falhou!" -ForegroundColor Red
            exit 1
        }
    } else {
        exit 1
    }
}

if (-not (Test-Path (Join-Path $FrontendPath "node_modules"))) {
    Write-Host "AVISO: Dependências do frontend não instaladas!" -ForegroundColor Yellow
    Write-Host "Execute primeiro: .\deploy.ps1" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Deseja executar o deploy agora? (S/N)"
    if ($response -eq "S" -or $response -eq "s") {
        & "$ProjectRoot\deploy.ps1"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERRO: Deploy falhou!" -ForegroundColor Red
            exit 1
        }
    } else {
        exit 1
    }
}

Write-Host "Iniciando Backend e Frontend..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Backend será executado em: http://localhost:4000" -ForegroundColor Cyan
Write-Host "Frontend será executado em: http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pressione Ctrl+C para parar ambos os servidores" -ForegroundColor Yellow
Write-Host ""

# Array para armazenar os processos
$jobs = @()

# Função para limpar processos ao sair
function Stop-AllProcesses {
    Write-Host "`n`nParando servidores..." -ForegroundColor Yellow
    foreach ($job in $jobs) {
        if ($job -and $job.State -eq "Running") {
            Stop-Job $job
            Remove-Job $job
        }
    }

    # Garantir que as portas sejam libertadas
    Get-Process -Name node -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*backend*" -or $_.CommandLine -like "*vite*"
    } | Stop-Process -Force -ErrorAction SilentlyContinue

    Write-Host "Servidores parados!" -ForegroundColor Green
    exit
}

# Registrar handler para Ctrl+C
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Stop-AllProcesses } | Out-Null

try {
    # Iniciar Backend
    Write-Host "Iniciando Backend..." -ForegroundColor Green
    $backendJob = Start-Job -ScriptBlock {
        param($path)
        Set-Location $path
        npm start
    } -ArgumentList $BackendPath
    $jobs += $backendJob

    # Aguardar um pouco para o backend iniciar
    Start-Sleep -Seconds 3

    # Iniciar Frontend
    Write-Host "Iniciando Frontend..." -ForegroundColor Green
    $frontendJob = Start-Job -ScriptBlock {
        param($path)
        Set-Location $path
        npm run dev
    } -ArgumentList $FrontendPath
    $jobs += $frontendJob

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Aplicação em execução!               " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""

    # Monitorar os jobs e mostrar output
    while ($true) {
        foreach ($job in $jobs) {
            $output = Receive-Job $job -ErrorAction SilentlyContinue
            if ($output) {
                Write-Host $output
            }

            # Verificar se o job falhou
            if ($job.State -eq "Failed") {
                Write-Host "ERRO: Um dos servidores falhou!" -ForegroundColor Red
                Stop-AllProcesses
            }
        }

        Start-Sleep -Milliseconds 500

        # Verificar se Ctrl+C foi pressionado
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "C" -and $key.Modifiers -eq "Control") {
                Stop-AllProcesses
            }
        }
    }
}
catch {
    Write-Host "`nERRO: $_" -ForegroundColor Red
    Stop-AllProcesses
}
finally {
    Stop-AllProcesses
}
