#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME="your_github_username"
TOKEN="your_personal_access_token"

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    echo "Fetching collaborators for ${REPO_OWNER}/${REPO_NAME}..."
    # Fetch the list of collaborators on the repository
    local response
    response=$(github_api_get "$endpoint")

    # Debugging: print raw response
    echo "Raw API response:"
    echo "$response"

    # Extract collaborators with read access
    collaborators=$(echo "$response" | jq -r '.[] | select(.permissions and .permissions.pull == true) | .login')

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
