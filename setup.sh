#!/bin/bash

# Jira Configuration
JIRA_URL="https://yourdomain.atlassian.net" # Replace with your Jira instance
JIRA_USER="your_email@example.com"          # Replace with your Jira email
JIRA_API_TOKEN="your_api_token"             # Replace with your Jira API token

# Encode authentication
AUTH=$(echo -n "$JIRA_USER:$JIRA_API_TOKEN" | base64)

# Create a Project
PROJECT_KEY="MTSP"  # Must be 2-10 uppercase characters
PROJECT_NAME="Mock Ticketing System"

CREATE_PROJECT_RESPONSE=$(curl -s -X POST "$JIRA_URL/rest/api/3/project" \
    -H "Authorization: Basic $AUTH" \
    -H "Content-Type: application/json" \
    -d '{
        "key": "'$PROJECT_KEY'",
        "name": "'$PROJECT_NAME'",
        "projectTypeKey": "software",
        "projectTemplateKey": "com.pyxis.greenhopper.jira:basic-software-development-template",
        "lead": "'$JIRA_USER'"
    }')

echo "Created Jira Project: $PROJECT_NAME"

# Add Issue Types and Fields
COMPLEXITY_FIELD=$(curl -s -X POST "$JIRA_URL/rest/api/3/field" \
    -H "Authorization: Basic $AUTH" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "Complexity",
        "description": "Ticket complexity level",
        "type": "option",
        "searcherKey": "multioption"
    }' | jq -r '.id')

echo "Created Custom Field for Complexity: $COMPLEXITY_FIELD"

# Create Tickets with Complexity
declare -A TICKETS
TICKETS["Login Issue"]="High"
TICKETS["Dark Mode Request"]="Medium"
TICKETS["Password Reset"]="Low"

for TICKET_NAME in "${!TICKETS[@]}"; do
    COMPLEXITY="${TICKETS[$TICKET_NAME]}"
    curl -s -X POST "$JIRA_URL/rest/api/3/issue" \
        -H "Authorization: Basic $AUTH" \
        -H "Content-Type: application/json" \
        -d '{
            "fields": {
                "project": {"key": "'$PROJECT_KEY'"},
                "summary": "'$TICKET_NAME'",
                "description": "Description for '$TICKET_NAME'",
                "issuetype": {"name": "Task"},
                "customfield_'$COMPLEXITY_FIELD'": ["'$COMPLEXITY'"]
            }
        }'
    echo "Created Ticket: $TICKET_NAME with Complexity: $COMPLEXITY"
done

echo "Jira setup completed."
