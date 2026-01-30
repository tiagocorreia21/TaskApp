# TaskApp - Script de Limpeza
# Remove node_modules e arquivos compilados

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   TaskApp - Limpeza de Arquivos       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este script irá remover:" -ForegroundColor Yellow
Write-Host "  • node_modules (root, backend, frontend)" -ForegroundColor Yellow
Write-Host "  • Arquivos compilados (build, dist)" -ForegroundColor Yellow
Write-Host "  • package-lock.json" -ForegroundColor Yellow
Write-Host ""

# Função para remover diretório com mensagem
function Remove-DirectoryWithMessage {
    param(
        [string]$Path,
        [string]$Description
    )

    if (Test-Path $Path) {
        Write-Host "🗑️  Removendo $Description..." -ForegroundColor Yellow
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path $Path)) {
            Write-Host "✓ $Description removido com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "⚠ Aviso: Não foi possível remover completamente $Description" -ForegroundColor Red
        }
    } else {
        Write-Host "○ $Description não existe (ok)" -ForegroundColor Gray
    }
}

# Função para remover arquivo com mensagem
function Remove-FileWithMessage {
    param(
        [string]$Path,
        [string]$Description
    )

    if (Test-Path $Path) {
        Write-Host "🗑️  Removendo $Description..." -ForegroundColor Yellow
        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path $Path)) {
            Write-Host "✓ $Description removido com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "⚠ Aviso: Não foi possível remover $Description" -ForegroundColor Red
        }
    } else {
        Write-Host "○ $Description não existe (ok)" -ForegroundColor Gray
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Removendo node_modules" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Remover node_modules
Remove-DirectoryWithMessage -Path ".\node_modules" -Description "node_modules (root)"
Remove-DirectoryWithMessage -Path ".\backend\node_modules" -Description "node_modules (backend)"
Remove-DirectoryWithMessage -Path ".\frontend\node_modules" -Description "node_modules (frontend)"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Removendo arquivos compilados" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Remover arquivos compilados
Remove-DirectoryWithMessage -Path ".\backend\build" -Description "build (backend)"
Remove-DirectoryWithMessage -Path ".\frontend\dist" -Description "dist (frontend)"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Removendo package-lock.json" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Remover package-lock.json
Remove-FileWithMessage -Path ".\package-lock.json" -Description "package-lock.json (root)"
Remove-FileWithMessage -Path ".\backend\package-lock.json" -Description "package-lock.json (backend)"
Remove-FileWithMessage -Path ".\frontend\package-lock.json" -Description "package-lock.json (frontend)"

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✓ Limpeza Concluída com Sucesso!    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "  Para reinstalar tudo, execute:" -ForegroundColor White
Write-Host "    .\setup.ps1" -ForegroundColor Yellow
Write-Host "  Ou:" -ForegroundColor White
Write-Host "    .\deploy.ps1" -ForegroundColor Yellow
Write-Host ""
