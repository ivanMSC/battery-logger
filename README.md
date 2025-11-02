# 🔋 Battery Logger for Windows
Battery Logger is a lightweight PowerShell-based tool that records your laptop's battery percentage automatically every few minutes.  
It runs silently in the background using Windows Task Scheduler and writes to a CSV log file for later analysis.

## Features
- Logs battery percentage every 5 minutes (default)
- Runs completely hidden
- Uses Windows Task Scheduler for automation
- Outputs data as a simple CSV:
```
Timestamp,BatteryPercentage,PowerSource,BatteryStatus,SaverMode
2025-11-01T23:25:18-03:00,48,Battery,AC - Charging,Off
```

## Installation
1. [Download and unzip](https://github.com/ivanMSC/battery-logger/archive/refs/heads/main.zip) or clone this repository.
2. Run ```setup_task.ps1``` from the installer folder (right click -> Run with PowerShell). This will create a scheduled task that runs every 5 minutes and executes the logger.
3. Check your log file after a 5 or more minutes: The CSV log is saved at ```battery_log.csv``` in the root folder of this repo, i.e. wherever you unziped the repository.

## Configuration
You can edit the logging interval by running ```setup_task.ps1``` with the ```-IntervalMinutes``` parameter:
```
.\setup_task.ps1 -IntervalMinutes 10
```
That will create or edit the task to run every 10 minutes.

## Uninstall
You can manually delete the scheduled task called "BatteryLogger" from Windows Task Scheduler, or run ```setup_task.ps1``` with the ```-Remove``` switch:
```
.\setup_task.ps1 -Remove
```

