<#
.SYNOPSIS
  Creates or updates a Windows Scheduled Task that runs the Battery Logger script silently.

.DESCRIPTION
  This script installs a Task Scheduler job that executes a VBScript launcher,
  which in turn runs the PowerShell battery logging script without showing any window.
  The interval can be customized using the -IntervalMinutes parameter.

.PARAMETER IntervalMinutes
  The repetition interval in minutes for the scheduled task. Default: 5

.PARAMETER Remove
  Optional switch to remove the scheduled task instead of creating it.

.EXAMPLE
  .\setup_task.ps1 -IntervalMinutes 10
  Creates the task to run every 10 minutes.

.EXAMPLE
  .\setup_task.ps1 -Remove
  Removes the scheduled task completely.

.NOTES
  Author: Ivan Gonzalez (https://github.com/ivanMSC/)
  Version: 1.0
  License: MIT
#>

param(
    [int]$IntervalMinutes = 5,
    [switch]$Remove
)

$taskName = "BatteryLogger"
$description = "Logs laptop battery percentage every $IntervalMinutes minute(s)."

# Determine VBS script path (relative to this file)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$vbsPath = Join-Path $scriptDir "..\src\RunBatteryLogger.vbs" | Resolve-Path

# Deleting task if -Remove switch
if ($Remove) {
    Write-Host "Removing scheduled task '$taskName'..." -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
        Write-Host "Task '$taskName' removed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to remove task (may not exist): $($_.Exception.Message)" -ForegroundColor Red
    }
    exit
}

Write-Host "Installing or updating Battery Logger task..." -ForegroundColor Cyan

# Define the trigger and action
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) `

$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$vbsPath`""
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Limited

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
        -Principal $principal -Description $description -Force

    Write-Host "Task '$taskName' successfully installed or updated." -ForegroundColor Green
    Write-Host "Interval: $IntervalMinutes minute(s)"
}
catch {
    Write-Host "Failed to install or update task: $($_.Exception.Message)" -ForegroundColor Red
}

# Display task info summary
Write-Host "`nTask info:" -ForegroundColor Cyan
Get-ScheduledTask -TaskName $taskName | Get-ScheduledTaskInfo | 
    Select-Object LastRunTime, NextRunTime | Format-Table

Read-Host -Prompt "Presione Enter para continuar..."