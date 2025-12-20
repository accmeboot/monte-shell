pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var workspaces: []
    property var windows: []

    function switchToWorkspace(workspaceIdx) {
        updateWindows.exec(["niri", "msg", "action", "focus-workspace", String(workspaceIdx)]);
    }

    function handleEventWorkspaces(event) {
        if (event.WorkspacesChanged && event.WorkspacesChanged.workspaces) {
            var eventWorkspaces = event.WorkspacesChanged.workspaces;
            var workspacesSorted = eventWorkspaces.slice().sort((a, b) => a.idx - b.idx);

            workspaces = workspacesSorted;
        }

        if (event.WorkspaceActivated && event.WorkspaceActivated.id) {
            workspaces = workspaces.slice().map(workspace => {
                workspace.is_active = workspace.id === event.WorkspaceActivated.id;

                return workspace;
            });
        }
    }

    function handleEventWindows(event) {
        if (event.WindowsChanged && event.WindowsChanged.windows) {
            updateWindows.exec(["niri", "msg", "--json", "windows"]);
        }

        if (event.WindowFocusChanged || event.WindowOpenedOrChanged) {
            updateWindows.exec(["niri", "msg", "--json", "windows"]);

            if (event.WindowFocusChanged?.id) {
                windows = windows.slice().map(window => {
                    window.is_focused = window.id === event.WindowFocusChanged.id;

                    return window;
                });
            }
        }
    }

    function getActiveWindow() {
        var activeWindowIdx = windows.findIndex(window => window.is_focused);
        return windows[activeWindowIdx];
    }

    Process {
        id: updateWindows
        command: ["niri", "msg", "--json", "windows"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    if (data) {
                        root.windows = JSON.parse(data);
                    }
                } catch (e) {
                    console.warn("Failed to parse windows:", e);
                }
            }
        }
    }

    Process {
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                try {
                    if (data) {
                        var event = JSON.parse(data);

                        root.handleEventWorkspaces(event);
                        root.handleEventWindows(event);
                    }
                } catch (e) {
                    console.warn("Failed to parse event:", e);
                }
            }
        }
    }
}
