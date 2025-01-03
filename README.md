# Jira-Setup-Automation

Windows:

Set up Jira API Token:

    Generate an API token from your Jira account settings.
    Replace YOUR_JIRA_API_TOKEN with your token.

Adjust Jira Domain:

    Replace https://yourdomain.atlassian.net with your Jira instance domain.

Customize Project and Statuses:

    Change $projectKey and $projectName to your desired values.
    Update the $statuses array to match your workflow.

Run the Script:

    Save as setup.ps1.
    Run in PowerShell.

Linux:

Jira Script:

    Replace JIRA_URL, JIRA_USER, and JIRA_API_TOKEN with your Jira instance, email, and API token.
    Update PROJECT_KEY and PROJECT_NAME as desired.
    Add or adjust the TICKETS array to include your tickets and their complexity.

Run the Script:

    Save each script as .sh and make them executable: chmod +x script.sh.
    Run: ./script.sh.

Verify Setup:

    Log in to Jira to confirm project, ticket, and task creation.
