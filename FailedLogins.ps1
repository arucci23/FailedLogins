# Define the time range (last 5 days)
$startDate = (Get-Date).AddDays(-5)

# Get event logs for failed logins (Event ID 4625) in the last 5 days
$failedLogins = Get-WinEvent -LogName Security | Where-Object {
    $_.Id -eq 4625 -and $_.TimeCreated -ge $startDate
}

# Check if there were any failed logins
if ($failedLogins.Count -gt 0) {
    # Group by account name
    $groupedLogins = $failedLogins | Group-Object -Property {@{Expression={$_.Properties[5].Value}}}
    
    foreach ($group in $groupedLogins) {
        $username = $group.Name
        $events = $group.Group | Sort-Object TimeCreated
        
        # Check for 3 or more failed logins within a 10-minute window
        for ($i = 0; $i -le $events.Count - 3; $i++) {
            $timeDiff = ($events[$i + 2].TimeCreated - $events[$i].TimeCreated).TotalMinutes
            
            if ($timeDiff -le 10) {
                # Create alert message
                $alertMessage = "ALERT: User '$username' has failed to log in 3 or more times within 10 minutes."
                
                # Set the webhook URL (Replace with your actual Microsoft Teams Incoming Webhook URL)
                $webhookUrl = "https://your-teams-webhook-url-here"
                
                # Prepare the message payload for Teams
                $teamsMessage = @{
                    "@type"    = "MessageCard"
                    "@context" = "http://schema.org/extensions"
                    "text"     = $alertMessage
                }
                
                # Convert to JSON and send the alert to Microsoft Teams
                Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($teamsMessage | ConvertTo-Json -Depth 3) -ContentType 'application/json'
                
                break  # Avoid duplicate alerts for the same user
            }
        }
    }
} else {
    Write-Host "No failed login attempts in the past 5 days."
}
