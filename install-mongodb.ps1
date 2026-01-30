#!/usr/bin/env pwsh
# Script para baixar e instalar MongoDB Memory Server binários
# Script to download and install MongoDB Memory Server binaries

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   MongoDB Memory Server - Setup        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# Obter o diretório raiz do projeto e salvar diretório atual
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalLocation = Get-Location
$BackendPath = Join-Path $ProjectRoot "backend"
$MongoDBBinariesPath = Join-Path $BackendPath "mongodb-binaries"

# Verificar se o backend existe
if (-not (Test-Path $BackendPath)) {
    Write-Host "ERRO: Diretório backend não encontrado!" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
}

# Verificar se node_modules existe
$nodeModulesPath = Join-Path $BackendPath "node_modules"
if (-not (Test-Path $nodeModulesPath)) {
    Write-Host "ERRO: Dependências do backend não estão instaladas!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, execute primeiro:" -ForegroundColor Yellow
    Write-Host "  cd backend" -ForegroundColor Gray
    Write-Host "  npm install" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Ou execute:" -ForegroundColor Yellow
    Write-Host "  .\deploy.ps1" -ForegroundColor Gray
    Write-Host ""
    Set-Location $OriginalLocation
    exit 1
}

# Verificar se mongodb-memory-server está instalado
$mongoMemoryServerPath = Join-Path $nodeModulesPath "mongodb-memory-server"
if (-not (Test-Path $mongoMemoryServerPath)) {
    Write-Host "ERRO: mongodb-memory-server não está instalado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Execute:" -ForegroundColor Yellow
    Write-Host "  cd backend" -ForegroundColor Gray
    Write-Host "  npm install" -ForegroundColor Gray
    Write-Host ""
    Set-Location $OriginalLocation
    exit 1
}

Write-Host "✓ Dependências verificadas" -ForegroundColor Green
Write-Host ""

# Criar diretório para binários se não existir
Write-Host "[1/3] Verificando diretório de binários..." -ForegroundColor Yellow
if (-not (Test-Path $MongoDBBinariesPath)) {
    Write-Host "  Criando diretório: $MongoDBBinariesPath" -ForegroundColor Gray
    New-Item -ItemType Directory -Path $MongoDBBinariesPath -Force | Out-Null
    Write-Host "✓ Diretório criado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "✓ Diretório já existe" -ForegroundColor Green
}
Write-Host ""

# Verificar se o binário já existe
Write-Host "[2/3] Verificando binário do MongoDB..." -ForegroundColor Yellow
$mongoExe = Get-ChildItem -Path $MongoDBBinariesPath -Filter "mongod-*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($mongoExe) {
    Write-Host "✓ Binário do MongoDB encontrado:" -ForegroundColor Green
    Write-Host "  Nome: $($mongoExe.Name)" -ForegroundColor Gray
    Write-Host "  Tamanho: $([math]::Round($mongoExe.Length / 1MB, 2)) MB" -ForegroundColor Gray
    Write-Host "  Caminho: $($mongoExe.FullName)" -ForegroundColor Gray
    Write-Host ""

    $response = Read-Host "Deseja baixar novamente? (s/N)"
    if ($response -ne 's' -and $response -ne 'S') {
        Write-Host "✓ Usando binário existente" -ForegroundColor Green
        Write-Host ""
        Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║   ✓ MongoDB já está configurado!      ║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
        Set-Location $OriginalLocation
        exit 0
    }

    Write-Host "  Removendo binário antigo..." -ForegroundColor Yellow
    Remove-Item -Path $mongoExe.FullName -Force
}
Write-Host ""

# Baixar o MongoDB executando um teste rápido
Write-Host "[3/3] Baixando MongoDB Memory Server..." -ForegroundColor Yellow
Write-Host "  Isso pode demorar alguns minutos..." -ForegroundColor Gray
Write-Host ""

Set-Location $BackendPath

# Criar script Node.js temporário para baixar o MongoDB
$downloadScript = @"
const { MongoMemoryServer } = require('mongodb-memory-server');

async function downloadMongoDB() {
    console.log('🔄 Iniciando download do MongoDB...');
    console.log('');

    try {
        const mongoServer = await MongoMemoryServer.create({
            instance: {
                dbName: 'test-download',
                storageEngine: 'ephemeralForTest',
            },
            binary: {
                version: '6.0.12',
                downloadDir: './mongodb-binaries',
            },
        });

        console.log('');
        console.log('✓ MongoDB baixado com sucesso!');
        console.log('  URI:', mongoServer.getUri());
        console.log('');

        await mongoServer.stop();
        console.log('✓ Servidor de teste parado');

        process.exit(0);
    } catch (error) {
        console.error('Erro ao baixar MongoDB:', error.message);
        process.exit(1);
    }
}

downloadMongoDB();
"@

$tempScriptPath = Join-Path $BackendPath "temp-download-mongodb.js"
$downloadScript | Out-File -FilePath $tempScriptPath -Encoding UTF8

try {
    node $tempScriptPath

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Download concluído com sucesso!" -ForegroundColor Green

        # Verificar novamente se o binário foi baixado
        $mongoExe = Get-ChildItem -Path $MongoDBBinariesPath -Filter "mongod-*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

        if ($mongoExe) {
            Write-Host ""
            Write-Host "Detalhes do binário:" -ForegroundColor Cyan
            Write-Host "  Nome: $($mongoExe.Name)" -ForegroundColor Gray
            Write-Host "  Tamanho: $([math]::Round($mongoExe.Length / 1MB, 2)) MB" -ForegroundColor Gray
            Write-Host "  Caminho: $($mongoExe.FullName)" -ForegroundColor Gray
        }
    } else {
        throw "Falha ao executar script de download"
    }
} catch {
    Write-Host ""
    Write-Host "ERRO: Falha ao baixar MongoDB!" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    Set-Location $OriginalLocation
    exit 1
} finally {
    # Remover script temporário
    if (Test-Path $tempScriptPath) {
        Remove-Item -Path $tempScriptPath -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✓ MongoDB Setup Concluído!          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "O MongoDB Memory Server está pronto para uso!" -ForegroundColor Cyan
Write-Host "A aplicação usará automaticamente este binário." -ForegroundColor Gray
Write-Host ""

# Voltar ao diretório original
Set-Location $OriginalLocation
