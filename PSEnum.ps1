# Initialisating database

Write-Host "Initialisation of database..."

$ouiFile = Get-Content "oui.json" -Raw | ConvertFrom-Json

Clear-Host

while ($true) {
    # Input and Setup Management
    Write-Host "--- PSEnum --- PowerShell Enumeration Software" -ForegroundColor Cyan
    $target = Read-Host "Enter the target IP "
    Write-Host "Checking if Target IP is online..." -ForegroundColor Yellow
    if (Test-Connection -ComputerName $target -Count 1 -Quiet) {
        Write-Host "$target Is Online." -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "$target Is Offline." -ForegroundColor Red
        Write-Host ""
        continue
    }

    # Enumeration & Scanning the IP

    Write-Host "Scanning IP..."
    Write-Host "Enumerating IP MAC Address..."

    $mac = (Get-NetNeighbor -IPAddress $target -ErrorAction SilentlyContinue).LinkLayerAddress

    Write-Host "Enumerating IP Constructor..."

    $cleanMac = $mac -replace "[-:]", ""

    $oui = $cleanMac.Substring(0,6)

    if ($oui.PSObject.Properties.Name -contains $oui) {
        $result = $ouiFile.$oui
    } else {
        $result = "Constructor Unknown."
    }

    # Printing all result
    Write-Host ""
    Write-Host "--- IP Enumeration Result ---" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Cyan
    Write-Host "MAC Adress : $mac" -ForegroundColor Cyan
    Write-Host "Constructor : $result"-ForegroundColor Cyan
    Write-Host "" -ForegroundColor Cyan
    Write-Host "-----------------------------" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Press Enter to continue..."
    [System.Console]::ReadKey($true) > $null
    Write-Host ""
}