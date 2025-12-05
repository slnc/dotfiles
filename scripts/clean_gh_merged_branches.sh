#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NO_COLOR='\033[0m'

# Check if gh is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: 'gh' command not found. Please install GitHub CLI.${NO_COLOR}"
    exit 1
fi

# Get main branch name
main_branch_name=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$main_branch_name" ]; then
    main_branch_name="main"
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

# Build a list of merged PR branches
echo -e "${BLUE}Fetching merged PRs from GitHub...${NO_COLOR}"
merged_branches=()
while IFS= read -r branch; do
    # Check if the branch exists locally
    if git show-ref --verify --quiet refs/heads/"$branch"; then
        # Don't include the main branch or current branch
        if [ "$branch" != "$main_branch_name" ] && [ "$branch" != "$current_branch" ]; then
            merged_branches+=("$branch")
        fi
    fi
done < <(gh pr list --author @me --state merged --limit 100 --json headRefName --jq '.[].headRefName' 2>/dev/null)

# Check if there are any branches to delete
if [ ${#merged_branches[@]} -eq 0 ]; then
    echo -e "${GREEN}No merged branches found to delete.${NO_COLOR}"
    exit 0
fi

# Display branches that will be deleted
echo -e "\n${YELLOW}The following local branches have merged PRs on GitHub:${NO_COLOR}"
for branch in "${merged_branches[@]}"; do
    echo -e "  ${RED}✗${NO_COLOR} $branch"
done

# Prompt for confirmation
echo -e "\n${YELLOW}Delete these ${#merged_branches[@]} branches? (y/N)${NO_COLOR} "
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}Deleting branches...${NO_COLOR}"
    for branch in "${merged_branches[@]}"; do
        if git branch -D "$branch" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NO_COLOR} Deleted $branch"
        else
            echo -e "  ${RED}✗${NO_COLOR} Failed to delete $branch"
        fi
    done
    echo -e "\n${GREEN}Done!${NO_COLOR}"
else
    echo -e "\n${YELLOW}Cancelled. No branches were deleted.${NO_COLOR}"
    exit 0
fi
