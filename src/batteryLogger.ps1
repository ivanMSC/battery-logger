<#
.SYNOPSIS
  Logs battery percentage to a CSV file every time it's executed.

.DESCRIPTION
  This script records the current battery percentage and other status parameters to a CSV file
  It also logs some energy status things like if it's plugged in, in battery saver mode, etc.
  Intended to be run periodically via Windows Task Scheduler.

  File:    batteryLogger.ps1
  Author:  Ivan Gonzalez (https://github.com/ivanMSC/)
  Version: 1.0
  License: MIT
#>

# Configuration
$repoRoot = Split-Path -Parent $PSScriptRoot
$LogPath = Join-Path $repoRoot "battery_log.csv"

# Create CSV with header if missing
if (!(Test-Path $LogPath)) {
    "Timestamp,BatteryPercentage,PowerSource,BatteryStatus,SaverMode" | Out-File -FilePath $LogPath -Encoding UTF8
}

# Get data
$timestamp = [datetimeoffset]::Now.ToString("yyyy-MM-ddTHH:mm:sszzz")
$battery = Get-WmiObject -Class Win32_Battery

# Extract fields safely
$percent = $battery.EstimatedChargeRemaining
$status = switch ($battery.BatteryStatus) {
    1 { "Discharging" }
    2 { "AC - Charging" }
    3 { "Fully Charged" }
    4 { "Low" }
    5 { "Critical" }
    6 { "Charging" }
    7 { "Charging + High" }
    8 { "Charging + Low" }
    9 { "Charging + Critical" }
    10 { "Undefined" }
    11 { "Partially Charged" }
    default { "Unknown" }
}

# Detect if plugged in (1 = AC, 0 = battery)
$powerSource = if ($battery.PowerOnline) { "AC" } else { "Battery" }

# Battery saver status
$powerCfg = powercfg /getactivescheme
$saverMode = if ((Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power").EnergySaverStatus -eq 1) { "On" } else { "Off" }

# Append log
"$timestamp,$percent,$powerSource,$status,$saverMode" | Out-File -FilePath $LogPath -Append -Encoding UTF8