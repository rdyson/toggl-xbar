#!/usr/bin/env bash

export PATH='/bin:/usr/local/bin:/usr/bin:/opt/homebrew/bin:$PATH'

#  <xbar.title>Toggl Multi-Workspace</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Rob Dyson</xbar.author>
#  <xbar.author.github>rdyson</xbar.author.github>
#  <xbar.desc>Displays current week's total time logged in Toggl for one or more workspaces, with configurable display of minutes and time limit.</xbar.desc>
#  <xbar.image>https://github.com/rdyson/toggl-xbar/blob/main/screenshot.png?raw=true</xbar.image>
#  <xbar.dependencies>jq</xbar.dependencies>
#  <xbar.var>string(VAR_WORKSPACES): Workspace ID(s). Separate multiple IDs with a space.</xbar.var>
#  <xbar.var>string(VAR_TOGGL_API_KEY): Toggl API Key.</xbar.var>
#  <xbar.var>select(VAR_WEEK_START_DAY="Sunday"): Week starts on [Monday, Sunday]</xbar.var>
#  <xbar.var>boolean(VAR_SHOW_MINUTES=true): Show minutes in output.</xbar.var>
#  <xbar.var>boolean(VAR_SHOW_COLORS=true): Whether to show colors.</xbar.var>
#  <xbar.var>number(VAR_TIME_LIMIT=40): Time limit in hours. If colors are enabled, text color chnages as you approach this limit.</xbar.var>
#  <xbar.abouturl>https://github.com/rdyson/toggl-xbar</xbar.abouturl>

# Specifies previous Sunday, can be changed to Monday if you prefer.
start_date=$(date -v -${VAR_WEEK_START_DAY} +"%Y"-"%m"-"%d")
total_seconds=0

# Loop over all workspaces in workspaces array, summing total seconds.
# Get the "tracked_seconds" value from the curl response and remove brackets and padding.
for workspace in ${VAR_WORKSPACES}
do
  workspace_seconds=$(curl \
    -u ${VAR_TOGGL_API_KEY}:api_token \
    -s \
    -X POST https://api.track.toggl.com/reports/api/v3/workspace/"$workspace"/projects/summary \
    -H "Content-Type: application/json" \
    -d '{"start_date":"'"$start_date"'"}' \
    | jq -c '[.[].tracked_seconds] | add' | sed 's/\[//' | sed 's/\]//')

  # If workspace_seconds is blank, set to 0.
  if [ ! "$workspace_seconds" ]
  then
   workspace_seconds=0
  fi

  # Add workspace_seconds to total_seconds.
  total_seconds=$(($total_seconds+$workspace_seconds))
done

# Calculate hours and minutes.
hours=$(($total_seconds / 3600))
minutes=$((($total_seconds % 3600) / 60))

# Output format based on VAR_SHOW_MINUTES.
if [ "$VAR_SHOW_MINUTES" = true ]; then
  output="${hours}h ${minutes}m"
else
  output="${hours}h"
fi

# Calculate percentage thresholds
RED_LIMIT=$VAR_TIME_LIMIT
ORANGE_LIMIT=$(echo "$VAR_TIME_LIMIT * 0.75" | bc)
YELLOW_LIMIT=$(echo "$VAR_TIME_LIMIT * 0.50" | bc)

# Determine color based on hours
color="#00FF00" # Green by default
if [ $(echo "$hours >= $RED_LIMIT" | bc) -eq 1 ]; then
  color="#FF0000" # Red
elif [ $(echo "$hours >= $ORANGE_LIMIT" | bc) -eq 1 ]; then
  color="#FFA500" # Orange
elif [ $(echo "$hours >= $YELLOW_LIMIT" | bc) -eq 1 ]; then
  color="#FFFF00" # Yellow
fi

# Print final result with color based on hours logged.
if $VAR_SHOW_COLORS; then
  echo "$output | color=$color"
else
  echo "$output"
fi

# Add menu item to go to Toggl website
echo "---"
echo "Toggl Website | href=http://track.toggl.com"
