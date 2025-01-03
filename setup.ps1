# Define Jira API Credentials
$jiraBaseUrl = "https://yourdomain.atlassian.net"
$username = "your_email@example.com"  # Your Jira email
$apiToken = "YOUR_JIRA_API_TOKEN"     # Your Jira API Token

# Encode credentials for authentication
$authHeader = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$username:$apiToken"))
}

# Create a new Jira Project
$projectKey = "MTSP"  # Must be 2-10 uppercase characters
$projectName = "Mock Ticketing System"
$createProjectBody = @{
    key = $projectKey
    name = $projectName
    projectTypeKey = "software"
    projectTemplateKey = "com.pyxis.greenhopper.jira:basic-software-development-template"
    lead = $username
} | ConvertTo-Json -Depth 10

$createProjectUrl = "$jiraBaseUrl/rest/api/3/project"
$projectResponse = Invoke-RestMethod -Uri $createProjectUrl -Headers $authHeader -Body $createProjectBody -Method Post -ContentType "application/json"
Write-Host "Created Project: $projectName with Key: $projectKey"

# Add Statuses (Columns)
$statuses = @("New Tickets", "In Progress", "Waiting for Response", "Resolved", "Closed")
foreach ($status in $statuses) {
    $createStatusBody = @{
        name = $status
        description = "$status for the $projectName project"
        statusCategory = "To Do"  # Adjust based on the column category
    } | ConvertTo-Json -Depth 10

    $createStatusUrl = "$jiraBaseUrl/rest/api/3/status"
    Invoke-RestMethod -Uri $createStatusUrl -Headers $authHeader -Body $createStatusBody -Method Post -ContentType "application/json"
    Write-Host "Created Status: $status"
}

# Add Labels for Complexity
$complexities = @("T1: Low Complexity", "T2: Medium Complexity", "T3: High Complexity")
Write-Host "Complexity Labels Available: $($complexities -join ', ')"

# Add Tickets with Complexity Assignment
$tickets = @(
    @{summary="Login Issue"; description="Users unable to login"; complexity="T3: High Complexity"},
    @{summary="Dark Mode Request"; description="Request for dark mode"; complexity="T2: Medium Complexity"},
    @{summary="Password Reset"; description="Forgot password support"; complexity="T1: Low Complexity"}
)

foreach ($ticket in $tickets) {
    $createTicketBody = @{
        fields = @{
            project = @{
                key = $projectKey
            }
            summary = $ticket.summary
            description = $ticket.description
            issuetype = @{
                name = "Task"
            }
            labels = @($ticket.complexity)
        }
    } | ConvertTo-Json -Depth 10

    $createTicketUrl = "$jiraBaseUrl/rest/api/3/issue"
    $ticketResponse = Invoke-RestMethod -Uri $createTicketUrl -Headers $authHeader -Body $createTicketBody -Method Post -ContentType "application/json"
    Write-Host "Created Ticket: $($ticket.summary) with Complexity: $($ticket.complexity)"
}

Write-Host "Jira Setup Completed!"
