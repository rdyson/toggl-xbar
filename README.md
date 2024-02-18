# Toggl xbar

Show how many hours you've logged in [Toggl](https://toggl.com) for the current week in the macOS toolbar using [xbar](https://xbarapp.com).

![screenshot-toolbar](https://github.com/rdyson/toggl-xbar/assets/360430/7db37a69-f8a2-4087-93b4-d88e24eaaba5)

## Background

[xbar](https://xbarapp.com) lets you "put anything in your macOS menu bar" (formerly known as Bitbar). [Toggl](https://toggl.com) is web-based time tracking software. This xbar plugin lets you see the hours you've logged this week across one or more Toggl workspaces.

## Setup

1. Download and install [xbar](https://xbarapp.com/dl).
2. Clone this repo.
3. Copy toggl.10m.sh into your xbar plugins folder, which is `~/Library/Application Support/xbar/plugins`.
4. Refresh xbar by clicking on the xbar icon in the toolbar and clicking "Refresh all".
5. Click on the plugin in the toolbar, which by default will display "0h", then click on xbar > Open plugin.
6. Enter Toggl workspace IDs in the Workspaces field. You can enter more than one, separated by spaces. You can find your workspace ID by navigating to https://track.toggl.com/organization and clicking on the workspace(s) you wish to track. The workspace ID is the ID after `/workspace/` in the settings URL. For example, in the URL `https://track.toggl.com/organization/123/workspaces/456/settings`, the workspace ID is `456`.
7. Enter a Toggl API key by navigating to https://track.toggl.com/profile and finding the API token section at the bottom of the page.
8. Optionally, change the "Week start day".
9. Refresh the plugin by clicking on the refresh icon at the top of the plugin dialog, or by clicking on the xbar icon and then xbar > Refresh.
