pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool isConnected: false

    property string connectionType: "none" // "wifi", "ethernet", "none"
    property string connectionName: "none"

    property int signalStrength: 0 // 0-100 for wifi

    Process {
        command: ["nmcli", "monitor"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                if (data.includes("Networkmanager is now in the")) {
                    if (data.includes("'connected'") || data.includes("'connected (site only)'")) {
                        root.isConnected = true;

                        updateConnectionInfo.running = true;
                    } else if (data.includes("'disconnected'") || data.includes("'disconnecting'")) {
                        root.isConnected = false;
                        root.connectionType = "none";
                        root.connectionName = "";
                        root.signalStrength = 0;
                    }
                }

                if (data.includes("using connection")) {
                    var match = data.match(/'([^']+)'/);
                    if (match) {
                        root.connectionName = match[1];
                    }
                }
            }
        }
    }

    Process {
        id: updateConnectionInfo
        command: ["nmcli", "-t", "-f", "TYPE,NAME,DEVICE", "connection", "show", "--active"]
        stdout: SplitParser {
            onRead: data => {
                if (!data || data.trim() === "")
                    return;
                var lines = data.trim().split("\n");

                if (lines.length > 0) {
                    var parts = lines[0].split(":");
                    var type = parts[0];

                    if (type === "loopback") {
                        return;
                    }

                    root.isConnected = true;
                    root.connectionName = parts[1];

                    if (type.includes("wireless") || type.includes("802-11-wireless")) {
                        root.connectionType = "wifi";

                        updateWifiSignal.running = true;
                    } else if (type.includes("ethernet") || type.includes("802-3-ethernet")) {
                        root.connectionType = "ethernet";
                        root.signalStrength = 0;
                    }
                }
            }
        }
    }

    Process {
        id: updateWifiSignal
        command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL device wifi list | grep '^\\*:' | cut -d: -f2"]
        stdout: SplitParser {
            onRead: data => {
                root.signalStrength = data.trim();
            }
        }
    }

    Component.onCompleted: {
        updateConnectionInfo.running = true;
    }

    Timer {
        interval: 30000
        running: root.connectionType === "wifi" && root.isConnected
        repeat: true
        onTriggered: () => {
            updateWifiSignal.running = true;
        }
    }
}
