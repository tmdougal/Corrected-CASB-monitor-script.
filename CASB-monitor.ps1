```powershell
# CASB Simulation Script - Cloud Application Access Monitor
# This script simulates a CASB by monitoring DNS queries and web traffic


# Create log directory

$LogPath = "C:\CASBLogs"

if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory -Force
}


# Define cloud services to monitor

$CloudServices = @{
    "login.microsoftonline.com" = "Microsoft 365"
    "accounts.google.com"       = "Google Workspace"
    "app.dropbox.com"           = "Dropbox"
    "login.salesforce.com"      = "Salesforce"
    "slack.com"                 = "Slack"
    "zoom.us"                   = "Zoom"
}


# Function to log cloud access attempts

function Log-CloudAccess {
    param(
        [string]$Service,
        [string]$Domain,
        [string]$User,
        [string]$Action
    )

    # Create a custom object for the log entry
    $LogEntry = [PSCustomObject]@{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Service   = $Service
        Domain    = $Domain
        User      = $User
        Action    = $Action
        Risk      = "Medium"
    }

    $LogFile = "$LogPath\CASB_Access_Log.csv"

    # Export the log entry as a readable CSV
    $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation

    Write-Host "CASB Alert: $Action to $Service detected for user $User" -ForegroundColor Yellow
}


# Function to check policy compliance

function Check-PolicyCompliance {
    param(
        [string]$Service,
        [string]$User
    )

    # Simulate policy checks

    $ComplianceStatus = "Compliant"
    $RiskLevel = "Low"


    # Example policy:
    # Block access to personal cloud storage during business hours

    $CurrentHour = (Get-Date).Hour

    if ($Service -eq "Dropbox" -and $CurrentHour -ge 9 -and $CurrentHour -le 17) {

        $ComplianceStatus = "Policy Violation"
        $RiskLevel = "High"

        Write-Host "CASB Policy Violation: Personal cloud storage access blocked during business hours" -ForegroundColor Red
    }


    return @{
        Compliance = $ComplianceStatus
        Risk       = $RiskLevel
    }
}


# Simulate cloud access monitoring

Write-Host "Starting CASB Cloud Access Monitoring..." -ForegroundColor Green

Write-Host "Monitoring cloud services: $($CloudServices.Values -join ', ')" -ForegroundColor Cyan


# Generate sample access logs

foreach ($domain in $CloudServices.Keys) {

    $service = $CloudServices[$domain]

    $user = "ADATUM\Administrator"


    Log-CloudAccess `
        -Service $service `
        -Domain $domain `
        -User $user `
        -Action "Login Attempt"


    $compliance = Check-PolicyCompliance `
        -Service $service `
        -User $user


    Write-Host "Service: $service | Compliance: $($compliance.Compliance) | Risk: $($compliance.Risk)" -ForegroundColor White
}


Write-Host "`nCASB monitoring simulation completed. Check logs at: $LogPath" -ForegroundColor Green
```
