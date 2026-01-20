#!/usr/bin/env python3
"""Git branches viewer."""

import argparse
import json
import os
import re
import subprocess

ICONS = {"merged": "", "open_pr": "", "review": ""}


# Column config: (header, width, align, color) - width=0 means no padding
COLUMNS = [
    ("Date", 10, "left", "cyan"),
    ("Ahe", 3, "right", "green"),
    ("Beh", 3, "right", "red"),
    ("Branch", 30, "left", "blue"),
    ("Worktree", 12, "left", "magenta"),
    ("Last Commit", 11, "right", "yellow"),
    ("Description", 0, "left", None),
]

# ANSI color codes
COLORS = {
    "red": "\033[31m", "green": "\033[32m", "blue": "\033[34m",
    "yellow": "\033[33m", "cyan": "\033[36m", "magenta": "\033[35m",
    "bright_red": "\033[91m", "bright_green": "\033[92m", "bright_blue": "\033[94m",
    "bright_yellow": "\033[93m", "bright_cyan": "\033[96m", "bright_magenta": "\033[95m",
    "reset": "\033[0m",
}


def strip_ansi(text: str) -> str:
    return re.compile(r'\033\[[0-9;]*m').sub('', text)


def display_width(text: str) -> int:
    return len(strip_ansi(text))


def pad(text: str, width: int, align: str = "left") -> str:
    """Pad text to exact display width."""
    if width == 0:
        return text
    padding_needed = width - display_width(text)
    if padding_needed <= 0:
        return text
    padding = " " * padding_needed
    return text + padding if align == "left" else padding + text


def truncate(text: str, max_width: int) -> str:
    if max_width <= 0 or len(text) <= max_width:
        return text
    return text[:max_width - 3] + "..."


def colorize(text: str, color: str | None) -> str:
    if color is None or color not in COLORS:
        return text
    return f"{COLORS[color]}{text}{COLORS['reset']}"


def run_git(*args: str) -> str:
    return subprocess.run(["git", *args], capture_output=True, text=True).stdout.strip()


def run_cmd(cmd: list[str]) -> str:
    try:
        return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()
    except FileNotFoundError:
        return ""


def get_main_branch() -> str:
    output = run_git("symbolic-ref", "refs/remotes/origin/HEAD")
    return output.replace("refs/remotes/origin/", "") if output else "main"


def get_current_branch() -> str:
    return run_git("rev-parse", "--abbrev-ref", "HEAD")


def get_worktree_map() -> dict[str, str]:
    """Build a map of branch -> worktree path."""
    worktree_map = {}
    for line in run_git("worktree", "list").split("\n"):
        if match := re.search(r'^(\S+).*\[([^\]]+)\]', line):
            worktree_map[match.group(2)] = match.group(1)
    return worktree_map


def get_branches(main_branch: str, show_merged: bool) -> list[dict]:
    """Get list of branches with metadata."""
    fmt = "%(authordate:short)@%(objectname:short)@%(refname:short)@%(committerdate:relative)"
    args = ["for-each-ref", "--sort=-authordate", f"--format={fmt}", "refs/heads/"]
    if not show_merged:
        args.extend(["--no-merged", main_branch])
    branches = []
    for line in run_git(*args).split("\n"):
        if parts := line.split("@"):
            if len(parts) >= 4:
                branches.append({"date": parts[0], "sha": parts[1], "name": parts[2], "time": parts[3]})
    return branches


def count_ahead_behind(sha: str, main_branch: str) -> tuple[int, int]:
    """Count commits ahead and behind main branch."""
    output = run_git("rev-list", "--left-right", "--count", f"{main_branch}...{sha}")
    if parts := output.split():
        if len(parts) == 2:
            return int(parts[1]), int(parts[0])  # ahead, behind
    return 0, 0


def get_pr_status(use_gh: bool) -> tuple[set[str], set[str], set[str]]:
    """Get sets of merged, open, and branches with unresolved PR comments."""
    merged_prs, open_prs, unresolved_prs = set(), set(), set()
    if not use_gh:
        return merged_prs, open_prs, unresolved_prs

    # Get current repo
    repo = run_cmd(["gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner"])
    if not repo:
        return merged_prs, open_prs, unresolved_prs

    # GraphQL query - gets all PR data in one call
    query = """
    query($q: String!) {
      search(query: $q, type: ISSUE, first: 50) {
        nodes {
          ... on PullRequest {
            headRefName
            state
            reviewThreads(first: 100) {
              nodes { isResolved }
            }
          }
        }
      }
    }
    """

    result = subprocess.run(
        ["gh", "api", "graphql", "-f", f"query={query}", "-f", f"q=is:pr author:@me repo:{repo}"],
        capture_output=True, text=True
    )

    if result.returncode != 0:
        return merged_prs, open_prs, unresolved_prs

    try:
        data = json.loads(result.stdout)
        for pr in data.get("data", {}).get("search", {}).get("nodes", []):
            branch = pr.get("headRefName")
            if not branch:
                continue

            state = pr.get("state")
            if state == "MERGED":
                merged_prs.add(branch)
            elif state == "OPEN":
                open_prs.add(branch)
                # Check for unresolved comments
                threads = pr.get("reviewThreads", {}).get("nodes", [])
                if any(not t.get("isResolved", True) for t in threads):
                    unresolved_prs.add(branch)
    except json.JSONDecodeError:
        pass

    return merged_prs, open_prs, unresolved_prs


def shorten_time(s: str) -> str:
    """Shorten relative time format (e.g., '3 days ago' -> '3d ago')."""
    for unit in ['seconds?', 'minutes?', 'hours?', 'days?', 'weeks?', 'months?', 'years?']:
        s = re.sub(f' {unit}', 'M' if 'month' in unit else unit[0], s)
    return s


def print_row(values: list[str], is_current: bool = False, is_separator: bool = False):
    """Print a row with proper padding and colors."""
    parts = []
    for value, (_, width, align, color) in zip(values, COLUMNS):
        if is_current and color:
            color = f"bright_{color}"
        padded = pad(value, width, "left" if is_separator else align)
        parts.append(colorize(padded, color))
    print(" ".join(parts))


def main():
    parser = argparse.ArgumentParser(description="Display git branches with metadata")
    parser.add_argument("--gh", action="store_true", help="Enable GitHub PR status")
    parser.add_argument("--merged", action="store_true", help="Show merged branches")
    args = parser.parse_args()

    main_branch = get_main_branch()
    current_branch = get_current_branch()
    worktree_map = get_worktree_map()
    merged_prs, open_prs, unresolved_prs = get_pr_status(args.gh)

    print_row([col[0] for col in COLUMNS])
    print_row(["-" * (col[1] or 11) for col in COLUMNS], is_separator=True)

    branches = get_branches(main_branch, args.merged)
    for branch_data in branches:
        branch = branch_data["name"]

        if branch == main_branch:
            continue

        is_current = branch == current_branch

        ahead, behind = count_ahead_behind(branch_data["sha"], main_branch)
        description = run_git("config", f"branch.{branch}.description")
        time_short = shorten_time(branch_data["time"])

        worktree_path = ""
        if branch in worktree_map:
            worktree_path = os.path.basename(worktree_map[branch])

        branch_display = ""
        if args.gh:
            # Only show merged icon if PR is merged AND branch has no new commits
            if branch in merged_prs and ahead == 0:
                branch_display = f"{ICONS['merged']} "
            elif branch in open_prs:
                if branch in unresolved_prs:
                    branch_display = f"{ICONS['review']} "
                else:
                    branch_display = f"{ICONS['open_pr']} "

        branch_display += branch

        branch_width = COLUMNS[3][1]  # Branch column width
        branch_display = truncate(branch_display, branch_width)

        values = [
            branch_data["date"],
            str(ahead),
            str(behind),
            branch_display,
            worktree_path,
            time_short,
            description,
        ]

        print_row(values, is_current)


if __name__ == "__main__":
    main()
