# FailedLogins

Windows Event Log Monitoring with PowerShell  

## Overview  
This PowerShell script monitors Windows Security Event Logs for failed login attempts (Event ID 4625) and sends alerts to Microsoft Teams via an Incoming Webhook when a user fails to log in **3 or more times within a 10-minute window**.  

## Features  
- Scans the last 5 days of event logs for failed logins  
- Groups failed login attempts by username  
- Detects 3 or more failed login attempts within 10 minutes  
- Sends an alert to Microsoft Teams if the threshold is met  
- Uses PowerShell + Windows Event Logs for security monitoring  

## Requirements  
- Windows PowerShell (v5.1 or later)  
- Administrator Privileges (to access Security logs)  
- Microsoft Teams Incoming Webhook (setup required)  

## Setup Instructions  

### 1. Enable Auditing for Failed Logins  
   - Open Local Security Policy (`secpol.msc`)  
   - Navigate to: Security Settings → Local Policies → Audit Policy  
   - Enable "Audit logon events" for "Failure"  

### 2. Get Your Microsoft Teams Webhook  
   - In Microsoft Teams, go to the desired channel  
   - Click (⋮) More Options → Connectors  
   - Search for "Incoming Webhook" and add it  
   - Copy the Webhook URL  

### 3. Run the Script  
   - Open PowerShell as Administrator  
   - Download or copy the script  
   - Replace `https://your-teams-webhook-url-here` with your actual webhook  
   - Run the script:  
     ```
     .\failed-logins-monitor.ps1
     ```  

## Example Output  
If a user fails to log in 3 or more times within 10 minutes, the script sends an alert to Teams:  
"ALERT: User 'john.doe' has failed to log in 3 or more times within 10 minutes."
