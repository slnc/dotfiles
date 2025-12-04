#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
# Bright colors for current branch
BRIGHT_CYAN='\033[1;96m'
BRIGHT_GREEN='\033[1;92m'
BRIGHT_RED='\033[1;91m'
BRIGHT_BLUE='\033[1;94m'
BRIGHT_YELLOW='\033[1;93m'
MAGENTA='\033[0;35m'
BRIGHT_MAGENTA='\033[1;95m'

width1=10
width2=3
width3=3
width4=30
width5=12
width6=11
width7=11

# Check arguments
USE_GH=false
SHOW_MERGED=false

for arg in "$@"; do
    case "$arg" in
        gh)
            USE_GH=true
            ;;
        --merged|merged)
            SHOW_MERGED=true
            ;;
    esac
done

# Build a map of merged PR branches if gh is enabled
declare -A merged_prs
if [ "$USE_GH" = true ]; then
    if command -v gh &> /dev/null; then
        while IFS= read -r branch; do
            merged_prs["$branch"]=1
        done < <(gh pr list --author @me --state merged --limit 30 --json headRefName --jq '.[].headRefName' 2>/dev/null)
    fi
fi

# Function to count commits
count_commits() {
    local branch="$1"
    local base_branch="$2"
    local ahead_behind

    ahead_behind=$(git rev-list --left-right --count "$base_branch"..."$branch")
    echo "$ahead_behind"
}

# Main script
main_branch_name=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$main_branch_name" ]; then
    main_branch_name="main"
fi
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Build a map of branch -> worktree path
declare -A worktree_map
while IFS= read -r line; do
    path=$(echo "$line" | awk '{print $1}')
    branch=$(echo "$line" | grep -oP '\[\K[^\]]+')
    if [ -n "$branch" ]; then
        worktree_map["$branch"]="$path"
    fi
done < <(git worktree list)

printf "${CYAN}%-${width1}s ${GREEN}%-${width2}s ${RED}%-${width3}s ${BLUE}%-${width4}s ${MAGENTA}%-${width5}s ${YELLOW}%-${width6}s ${NO_COLOR}%-${width7}s\n" "Date" "Ahe" "Beh" "Branch" "Worktree" "Last Commit" "Description"

# Separator line for clarity
printf "${CYAN}%-${width1}s ${GREEN}%-${width2}s ${RED}%-${width3}s ${BLUE}%-${width4}s ${MAGENTA}%-${width5}s ${YELLOW}%-${width6}s ${NO_COLOR}%-${width7}s\n" "----------" "---" "---" "------------------------------" "------------" "-----------" "-----------"

format_string="%(authordate:short)@%(objectname:short)@%(refname:short)@%(committerdate:relative)"
IFS=$'\n'

# Determine whether to show merged branches
if [ "$SHOW_MERGED" = true ]; then
    branch_list=$(git for-each-ref --sort=-authordate --format="$format_string" refs/heads/)
else
    branch_list=$(git for-each-ref --sort=-authordate --format="$format_string" refs/heads/ --no-merged "$main_branch_name")
fi

for branchdata in $branch_list; do
    author_date=$(echo "$branchdata" | cut -d '@' -f1)
    sha=$(echo "$branchdata" | cut -d '@' -f2)
    branch=$(echo "$branchdata" | cut -d '@' -f3)
    time=$(echo "$branchdata" | cut -d '@' -f4)

    # Skip the main branch itself
    if [ "$branch" = "$main_branch_name" ]; then
        continue
    fi

    # Get branch description
    description=$(git config branch."$branch".description)

    # Count commits ahead and behind
    ahead_behind=$(count_commits "$sha" "$main_branch_name")
    ahead=$(echo "$ahead_behind" | cut -f2)
    behind=$(echo "$ahead_behind" | cut -f1)

    # Get worktree path if branch is checked out (show only dirname)
    worktree_path=""
    if [ -n "${worktree_map[$branch]}" ]; then
        worktree_path=$(basename "${worktree_map[$branch]}")
    fi

    # Build branch display with indicators
    if [ "$branch" = "$current_branch" ]; then
        branch_display="* "
    else
        branch_display=""
    fi

    # Add merged indicator if this branch has a merged PR
    if [ "$USE_GH" = true ] && [ -n "${merged_prs[$branch]}" ]; then
        branch_display="${branch_display} "
    fi

    branch_display="${branch_display}${branch}"

    # Truncate branch name to 30 chars
    if [ ${#branch_display} -gt 30 ]; then
        branch_display="${branch_display:0:27}..."
    fi

    # Shorten time format (e.g. "18 minutes ago" -> "18m ago")
    time_short=$(echo "$time" | sed 's/ minutes/m/g; s/ minute/m/g; s/ hours/h/g; s/ hour/h/g; s/ days/d/g; s/ day/d/g; s/ weeks/w/g; s/ week/w/g; s/ months/M/g; s/ month/M/g; s/ years/y/g; s/ year/y/g; s/ / /g')

    # Check if this is the current branch and use bright colors
    if [ "$branch" = "$current_branch" ]; then
        printf "${BRIGHT_CYAN}%-${width1}s ${BRIGHT_GREEN}%-${width2}s ${BRIGHT_RED}%-${width3}s ${BRIGHT_BLUE}%-${width4}s ${BRIGHT_MAGENTA}%-${width5}s ${BRIGHT_YELLOW}%${width6}s ${NO_COLOR}%-${width7}s\n" "$author_date" "$ahead" "$behind" "$branch_display" "$worktree_path" "$time_short" "$description"
    else
        printf "${CYAN}%-${width1}s ${GREEN}%-${width2}s ${RED}%-${width3}s ${BLUE}%-${width4}s ${MAGENTA}%-${width5}s ${YELLOW}%${width6}s ${NO_COLOR}%-${width7}s\n" "$author_date" "$ahead" "$behind" "$branch_display" "$worktree_path" "$time_short" "$description"
    fi
done
