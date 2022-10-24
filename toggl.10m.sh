#!/bin/sh
export PATH='/bin:/usr/local/bin:/usr/bin:/opt/homebrew/bin:$PATH'
#  <xbar.title>Toggl Xbar</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Rob Dyson</xbar.author>
#  <xbar.author.github>rdyson</xbar.author.github>
#  <xbar.desc>Displays current week's total time logged in Toggl for one or more workspaces</xbar.desc>

# Separate multiple workspaces with a space
workspaces=(2838545 6790797)

# Specifies previous Monday, can be changed to Sunday if you prefer
start_date=$(date -v -Monday +"%Y"-"%m"-"%d")

# Loop over all workspaces in workspaces array, summing total seconds.
# Curl uses login credentials stored in ~/.netrc, see repo for an example.
# Get the "tracked_seconds" value from the curl response and remov brackets and padding.

for workspace in ${workspaces[@]}
do
 workspace_seconds=$(curl -s -X POST https://api.track.toggl.com/reports/api/v3/workspace/"$workspace"/projects/summary \
  -H "Content-Type: application/json" \
  -d '{"start_date":"'"$start_date"'"}' \
  -n | jq -c '[.[].tracked_seconds'] | sed 's/\[//' | sed 's/\]//' | sed 's/,/+/g')

  # If workspace_seconds is blank, set to 0.
  if [ ! "$workspace_seconds" ]
  then
   workspace_seconds=0
  fi 

   # Add workspace_seconds to total_seconds.
   total_seconds=$(($total_seconds+$workspace_seconds))
done

# Print total seconds as hours.
if [[ $total_seconds == 0 ]]
then
 echo "0h";
else
 awk  'BEGIN { rounded = sprintf("%.0f", "'"$total_seconds"'"/3600); hours = "h"; result = rounded hours; print result }'
fi
