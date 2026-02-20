# Initialisating values

Write-Host "Initialisation of values..." -ForegroundColor Yellow

# Creating a table with each os and their default TTL
$TTL_Table = @{
    128 = "Windows"
    64 = "Linux/Android/MacOS"
    255 = "Router"
}

# Define oui file

$ouiFile = Get-Content "oui.json" -Raw | ConvertFrom-Json

# Clear Terminal
Clear-Host

# Main inf loop
while ($true) {
    # Input and Setup Management
    Write-Host "--- PSEnum --- PowerShell Enumeration Software" -ForegroundColor Cyan
    $target = Read-Host "Enter the target IP "
    Write-Host "Checking if Target IP is online..." -ForegroundColor Yellow
    # Check if Target IP is online or not
    # If Target IP is online
    if (Test-Connection -ComputerName $target -Count 1 -Quiet) {
        Write-Host "$target Is Online." -ForegroundColor Green
        Write-Host ""
    } 
    # If Target IP is offline
    else {
        Write-Host "$target Is Offline." -ForegroundColor Red
        Write-Host ""
        continue
    }

    # Enumeration & Scanning the IP

    Write-Host "Scanning IP..." -ForegroundColor Yellow

    # Getting Target IP Mac Address
    Write-Host "Enumerating IP MAC Address..." -ForegroundColor Yellow

    $mac = (Get-NetNeighbor -IPAddress $target -ErrorAction SilentlyContinue).LinkLayerAddress

    # Getting Target IP Constructor
    Write-Host "Enumerating IP Constructor..." -ForegroundColor Yellow

    # Cleaning Target IP MAC Asress
    $cleanMac = $mac -replace "[-:]", ""

    # Define Target IP MAC Address oui
    $oui = $cleanMac.Substring(0,6)

    # Checking if oui exist in the current database
    if ($oui.PSObject.Properties.Name -contains $oui) {
        $result = $ouiFile.$oui
    }
    # If constructor is Unknown
    else {
        $result = "Constructor Unknown."
    }

    # Getting Target IP OS
    Write-Host "Enumerating Device OS..." -ForegroundColor Yellow

    # Getting ping result

    $pingResult = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue

    # Doing random math stuff or smth i guess

    if ($pingResult) {
        $TTL_Value = $pingResult[0].ReplyDetails.Ttl

        $closestTTL = ($TTL_Table.Keys | Sort-Object {[math]::Abs($_ - $TTL_Value)})[0]
        $os = $TTL_Table[$closestTTL]
    }
    
    # Generating Scanning Result

    Write-Host "Generating Result..." -ForegroundColor Yellow

    # Writing all result

    Write-Host ""
    Write-Host "--- IP Enumeration Result ---" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Cyan
    Write-Host "MAC Adress : $mac" -ForegroundColor Cyan
    Write-Host "Constructor : $result"-ForegroundColor Cyan
    Write-Host "OS : $os" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor Cyan
    Write-Host "-----------------------------" -ForegroundColor Cyan
    Write-Host ""

    # Finishing with final instruction

    Write-Host "Press a Key to continue. Press CTRL + C to exit."
    [System.Console]::ReadKey($true) > $null
    Write-Host ""
}
