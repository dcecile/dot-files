#!/bin/bash

# Read Claude Code metadata from stdin
input=$(cat)

# Extract Claude Code metadata without requiring an external jq install.
mapfile -t metadata < <(printf '%s' "$input" | python3 -c '
import json
import sys

data = json.load(sys.stdin)
model = data.get("model") or {}
effort = data.get("effort") or {}
style = data.get("output_style") or {}
cost = data.get("cost") or {}
workspace = data.get("workspace") or {}
context = data.get("context_window") or {}
limits = data.get("rate_limits") or {}
five_hour = limits.get("five_hour") or {}
seven_day = limits.get("seven_day") or {}

def remaining(bucket):
    used = bucket.get("used_percentage")
    return "" if used is None else str(100 - used)

for value in (
    model.get("display_name") or model.get("id") or "unknown",
    effort.get("level") or "",
    style.get("name") or "Default",
    cost.get("total_lines_added", 0),
    cost.get("total_lines_removed", 0),
    workspace.get("current_dir") or data.get("cwd") or "",
    context.get("remaining_percentage") or "",
    remaining(five_hour),
    remaining(seven_day),
):
    print(value)
')
model_id=${metadata[0]}
effort_level=${metadata[1]}
output_style=${metadata[2]}
lines_added=${metadata[3]}
lines_removed=${metadata[4]}
cwd=${metadata[5]}
dir_name=$(basename "$cwd")
ctx_left=${metadata[6]}
rl_5h_left=${metadata[7]}
rl_7d_left=${metadata[8]}

# Git status detection (with optional locks disabled for performance)
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks rev-parse --short HEAD 2>/dev/null)

    # Check for dirty working tree
    if ! git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks diff --quiet 2>/dev/null || ! git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks diff --cached --quiet 2>/dev/null; then
        dirty=" ✗"
    else
        dirty=""
    fi

    # Format git info with colors
    git_info=$(printf "    \033[1;34mgit:(\033[0;31m%s\033[1;34m)%s\033[0m" "$branch" "$dirty")
fi

# Format model info (with reasoning effort, if applicable)
if [ -n "$effort_level" ]; then
    model_info=$(printf "    \033[0;35m%s (%s)\033[0m" "$model_id" "$effort_level")
else
    model_info=$(printf "    \033[0;35m%s\033[0m" "$model_id")
fi

# Context window remaining (only shown once populated)
ctx_info=""
if [ -n "$ctx_left" ]; then
    ctx_pct=$(printf '%.0f' "$ctx_left")
    ctx_info=$(printf "    \033[1;36mctx %s%% left\033[0m" "$ctx_pct")
fi

# Rate limits: 5h / weekly remaining (Pro/Max subscribers only, absent otherwise)
rate_info=""
if [ -n "$rl_5h_left" ] || [ -n "$rl_7d_left" ]; then
    rate_parts=""
    if [ -n "$rl_5h_left" ]; then
        rate_parts="5h $(printf '%.0f' "$rl_5h_left")% left"
    fi
    if [ -n "$rl_7d_left" ]; then
        weekly_part="weekly $(printf '%.0f' "$rl_7d_left")% left"
        rate_parts="${rate_parts:+$rate_parts, }$weekly_part"
    fi
    rate_info=$(printf "    \033[1;31m%s\033[0m" "$rate_parts")
fi

style_info=$(printf "    \033[0;33moutput: %s\033[0m" "$output_style")

# Format lines changed (only if there are changes)
lines_info=""
if [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; then
    lines_info=$(printf "    \033[0;32m+%s\033[0m \033[0;31m-%s\033[0m" "$lines_added" "$lines_removed")
fi

# Combine everything
printf "\033[0;36m%s\033[0m%s%s%s%s%s%s" "$dir_name" "$git_info" "$model_info" "$ctx_info" "$rate_info" "$style_info" "$lines_info"
