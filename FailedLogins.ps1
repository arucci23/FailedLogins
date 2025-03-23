# Define the time range (last 5 days)
$startDate = (Get-Date).AddDays(-5)  # Adjust the range as needed

# Get event logs for failed logins (Event ID 4625) in the last 5 days
$failedLogins = Get-WinEvent -LogName Security | Where-Object {
    $_.Id -eq 4625 -and $_.TimeCreated -ge $startDate
}

# Check if there were any failed logins
if ($failedLogins.Count -gt 0) {
    # Group by account name and count the failed logins per user
    $failedLogins | Group-Object -Property @{Expression={$_.Properties[5].Value}} | ForEach-Object {
        $username = $_.Name
        $loginCount = $_.Count

        # Create alert message
        $alertMessage = "ALERT: User '$username' has failed to log in $loginCount times in the past 5 days."

        # Set the webhook URL (Replace with your actual Microsoft Teams Incoming Webhook URL)
        $webhookUrl = "https://your-teams-webhook-url-here"

        # Prepare the message payload for Teams
        $teamsMessage = @{
            "@type"    = "MessageCard"
            "@context" = "http://schema.org/extensions"
            "text"     = $alertMessage
        }

        # Convert to JSON and send the alert to Microsoft Teams
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($teamsMessage | ConvertTo-Json) -ContentType 'application/json'
    }
} else {
    Write-Host "No failed login attempts in the past 5 days."
}
