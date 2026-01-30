# Script to kill process running on port 4000
$port = 4000

Write-Host "Checking for processes on port $port..." -ForegroundColor Yellow

$process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

if ($process) {
    $processId = $process.OwningProcess | Select-Object -Unique

    foreach ($pid in $processId) {
        Write-Host "Found process $pid using port $port. Terminating..." -ForegroundColor Red
        Stop-Process -Id $pid -Force
        Write-Host "Process $pid terminated successfully." -ForegroundColor Green
    }
} else {
    Write-Host "No process found on port $port. Port is free." -ForegroundColor Green
}

