#!/usr/bin/env pwsh
# Script para parar todos os servidores em execução
# Script to stop all running servers

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  Parando Servidores TaskApp           " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$ErrorActionPreference = "SilentlyContinue"

# Função para encontrar processos Node.js relacionados ao projeto
function Get-TaskAppProcesses {
    $processes = Get-Process -Name node -ErrorAction SilentlyContinue
    return $processes
}

# Função para liberar portas
function Stop-PortProcesses {
    param([int[]]$ports)

    foreach ($port in $ports) {
        Write-Host "Liberando porta $port..." -ForegroundColor Yellow

        # Encontrar processos usando a porta
        $netstat = netstat -ano | Select-String ":$port\s" | ForEach-Object { $_ -match '\s+(\d+)$' | Out-Null; $matches[1] } | Select-Object -Unique

        foreach ($pid in $netstat) {
            if ($pid) {
                try {
                    $process = Get-Process -Id $pid -ErrorAction Stop
                    Write-Host "  Parando processo $($process.Name) (PID: $pid)..." -ForegroundColor Gray
                    Stop-Process -Id $pid -Force -ErrorAction Stop
                    Write-Host "  ✓ Processo parado" -ForegroundColor Green
                } catch {
                    Write-Host "  ⚠ Não foi possível parar o processo (PID: $pid)" -ForegroundColor Yellow
                }
            }
        }
    }
}

# Parar processos do Node.js
Write-Host "Procurando processos Node.js..." -ForegroundColor Yellow
$nodeProcesses = Get-TaskAppProcesses

if ($nodeProcesses) {
    Write-Host "Encontrados $($nodeProcesses.Count) processo(s) Node.js" -ForegroundColor Cyan

    $confirm = Read-Host "Deseja parar TODOS os processos Node.js? (S/N)"

    if ($confirm -eq "S" -or $confirm -eq "s") {
        foreach ($proc in $nodeProcesses) {
            try {
                Write-Host "  Parando processo Node.js (PID: $($proc.Id))..." -ForegroundColor Gray
                Stop-Process -Id $proc.Id -Force
                Write-Host "  ✓ Processo parado" -ForegroundColor Green
            } catch {
                Write-Host "  ⚠ Não foi possível parar o processo" -ForegroundColor Yellow
            }
        }
    }
} else {
    Write-Host "Nenhum processo Node.js encontrado" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Liberando portas 4000 e 5173..." -ForegroundColor Yellow
Stop-PortProcesses -ports @(4000, 5173)

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✓ Limpeza concluída!                  " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "As portas 4000 e 5173 foram liberadas." -ForegroundColor Cyan
Write-Host "Você pode iniciar a aplicação novamente com: .\start.ps1" -ForegroundColor Cyan
Write-Host ""
