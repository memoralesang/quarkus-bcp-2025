# Utility script for executing the same command in multiple parallel threads.

param(
    [int]$Requests = 10
)

$command = { curl.exe -s http://localhost:8080/products/1/priceHistory > $null }

Write-Host ""

for ($i = 1; $i -le $Requests; $i++) {
    Write-Host "Sending request..."
    Start-Job $command | Out-Null
    Start-Sleep -Milliseconds 100
}

# Esperar a que terminen todos los jobs
Get-Job | Wait-Job | Receive-Job
Remove-Job *
