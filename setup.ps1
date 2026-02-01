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
Write-Host "[1/5] Verificando Node.js..." -ForegroundColor Yellow

$nodePath = Get-NodePath

if (-not $nodePath) {
    Write-Host "Node.js não está instalado!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opções disponíveis:" -ForegroundColor Cyan
    Write-Host "  1. Instalar Node.js localmente no projeto (recomendado)" -ForegroundColor White
    Write-Host "  2. Instalar Node.js globalmente (https://nodejs.org/)" -ForegroundColor White
    Write-Host "  3. Cancelar" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "Escolha uma opção (1-3)"

    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "Instalando Node.js localmente..." -ForegroundColor Yellow
        & "$ProjectRoot\install-nodejs.ps1" -SkipConfirmation

        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERRO: Falha ao instalar Node.js localmente!" -ForegroundColor Red
            exit 1
        }

        # Verificar novamente após instalação
        $nodePath = Get-NodePath
        if (-not $nodePath) {
            Write-Host "ERRO: Node.js não foi instalado corretamente!" -ForegroundColor Red
            exit 1
        }
    } elseif ($choice -eq "2") {
        Write-Host ""
        Write-Host "Por favor, instale Node.js de https://nodejs.org/ e execute este script novamente." -ForegroundColor Yellow
        Write-Host "Pressione qualquer tecla para abrir o site do Node.js..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Start-Process "https://nodejs.org/"
        exit 1
    } else {
        Write-Host "Instalação cancelada pelo usuário." -ForegroundColor Yellow
        exit 1
    }
}

if ($nodePath.IsLocal) {
    $nodeVersion = & $nodePath.Node --version
    Write-Host "Node.js local encontrado: $nodeVersion" -ForegroundColor Green
} else {
    $nodeVersion = node --version
    Write-Host "Node.js do sistema encontrado: $nodeVersion" -ForegroundColor Green
}

# Verificar npm
Write-Host "[2/5] Verificando npm..." -ForegroundColor Yellow

if ($nodePath.IsLocal) {
    $npmVersion = & $nodePath.Node $nodePath.Npm --version
    Write-Host "npm encontrado (local): v$npmVersion" -ForegroundColor Green
} else {
    if (-not (Test-CommandExists "npm")) {
        Write-Host "ERRO: npm não está instalado!" -ForegroundColor Red
        exit 1
    }
    $npmVersion = npm --version
    Write-Host "npm encontrado: v$npmVersion" -ForegroundColor Green
}


# Instalar dependências do root
Write-Host "[3/5] Instalando dependências globais do projeto..." -ForegroundColor Yellow
Set-Location $ProjectRoot
if ($nodePath.IsLocal) {
    & $nodePath.Node $nodePath.Npm install --loglevel=error
} else {
    npm install --loglevel=error
}
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
    if ($nodePath.IsLocal) {
        & $nodePath.Node $nodePath.Npm install -g concurrently --silent
    } else {
        npm install -g concurrently --silent
    }
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

