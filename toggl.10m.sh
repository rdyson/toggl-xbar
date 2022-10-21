#!/bin/sh
export PATH='/usr/local/bin:/usr/bin:/opt/homebrew/bin:$PATH'
#  <xbar.title>Toggle Bar</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Rob Dyson</xbar.author>
#  <xbar.author.github>rdyson</xbar.author.github>
#  <xbar.desc>Displays current week's total time logged in Toggl</xbar.desc>

workspace_one=2838545
workspace_two=6790797

one=$(curl -s -X POST https://api.track.toggl.com/reports/api/v3/workspace/"$workspace_one"/projects/summary \
  -H "Content-Type: application/json" \
  -d '{"start_date":"2022-10-17"}' \
  -n | jq -c '[.[].tracked_seconds'] | sed 's/\[//' | sed 's/\]//' | sed 's/,/+/g')

two=$(curl -s -X POST https://api.track.toggl.com/reports/api/v3/workspace/"$workspace_two"/projects/summary \
  -H "Content-Type: application/json" \
  -d '{"start_date":"2022-10-17"}' \
  -n | jq -c '[.[].tracked_seconds'] | sed 's/\[//' | sed 's/\]//' | sed 's/,/+/g')

echo "$((($one+$two)/3600))h";
