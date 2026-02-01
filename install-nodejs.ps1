#!/usr/bin/env pwsh
# Script para instalar Node.js localmente no projeto
# Script to install Node.js locally in the project

param(
    [string]$NodeVersion = "20.20.0",
    [switch]$SkipConfirmation = $false
)

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Instalador Local de Node.js         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# Obter o diretório raiz do projeto
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$NodeLocalPath = Join-Path $ProjectRoot "nodejs-local"
$NodeArchive = Join-Path $ProjectRoot "node-temp.zip"

# Detectar arquitetura do sistema
$arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
$NodeDownloadUrl = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-$arch.zip"

Write-Host "Configuração:" -ForegroundColor Yellow
Write-Host "  Versão do Node.js: v$NodeVersion" -ForegroundColor Gray
Write-Host "  Arquitetura: $arch" -ForegroundColor Gray
Write-Host "  Diretório de instalação: $NodeLocalPath" -ForegroundColor Gray
Write-Host ""

# Verificar se já existe instalação local
if (Test-Path $NodeLocalPath) {
    Write-Host "Node.js local já está instalado!" -ForegroundColor Green
    $nodeExe = Get-ChildItem -Path $NodeLocalPath -Filter "node.exe" -Recurse | Select-Object -First 1
    if ($nodeExe) {
        $localNodeVersion = & $nodeExe.FullName --version
        Write-Host "Versão instalada: $localNodeVersion" -ForegroundColor Green

        if (-not $SkipConfirmation) {
            Write-Host ""
            $response = Read-Host "Deseja reinstalar? (S/N)"
            if ($response -ne "S" -and $response -ne "s") {
                Write-Host "Instalação cancelada." -ForegroundColor Yellow
                exit 0
            }
            Write-Host "Removendo instalação anterior..." -ForegroundColor Yellow
            Remove-Item -Path $NodeLocalPath -Recurse -Force
        } else {
            Write-Host "✓ Node.js local já disponível (pulando reinstalação)" -ForegroundColor Green
            exit 0
        }
    }
}

# Criar diretório temporário
Write-Host "[1/4] Preparando diretórios..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $NodeLocalPath -Force | Out-Null
Write-Host "✓ Diretórios preparados" -ForegroundColor Green

# Download do Node.js
Write-Host "[2/4] Baixando Node.js v$NodeVersion..." -ForegroundColor Yellow
Write-Host "URL: $NodeDownloadUrl" -ForegroundColor Gray

try {
    # Usar WebClient para download com barra de progresso
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($NodeDownloadUrl, $NodeArchive)
    Write-Host "✓ Download concluído" -ForegroundColor Green
} catch {
    Write-Host "✗ ERRO: Falha ao baixar Node.js!" -ForegroundColor Red
    Write-Host "  Mensagem: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique:" -ForegroundColor Yellow
    Write-Host "  - Conexão com a internet" -ForegroundColor Gray
    Write-Host "  - URL de download: $NodeDownloadUrl" -ForegroundColor Gray
    exit 1
}

# Extrair arquivo
Write-Host "[3/4] Extraindo arquivos..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $NodeArchive -DestinationPath $NodeLocalPath -Force
    Write-Host "✓ Extração concluída" -ForegroundColor Green
} catch {
    Write-Host "✗ ERRO: Falha ao extrair arquivo!" -ForegroundColor Red
    Write-Host "  Mensagem: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Limpar arquivo temporário
Remove-Item -Path $NodeArchive -Force -ErrorAction SilentlyContinue

# Verificar instalação
Write-Host "[4/4] Verificando instalação..." -ForegroundColor Yellow

$nodeExe = Get-ChildItem -Path $NodeLocalPath -Filter "node.exe" -Recurse | Select-Object -First 1
$npmCmd = Get-ChildItem -Path $NodeLocalPath -Filter "npm.cmd" -Recurse | Select-Object -First 1

if ($nodeExe -and $npmCmd) {
    $installedVersion = & $nodeExe.FullName --version
    $installedNpmVersion = & $nodeExe.FullName $npmCmd.FullName --version

    Write-Host "✓ Node.js instalado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detalhes da instalação:" -ForegroundColor Cyan
    Write-Host "  Node.js: $installedVersion" -ForegroundColor Gray
    Write-Host "  npm: v$installedNpmVersion" -ForegroundColor Gray
    Write-Host "  Localização: $NodeLocalPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "NOTA: Os scripts do projeto usarão automaticamente esta instalação." -ForegroundColor Yellow
} else {
    Write-Host "✗ ERRO: Instalação incompleta!" -ForegroundColor Red
    Write-Host "Executáveis do Node.js não foram encontrados." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Instalação concluída com sucesso! ✓" -ForegroundColor Green
Write-Host ""
