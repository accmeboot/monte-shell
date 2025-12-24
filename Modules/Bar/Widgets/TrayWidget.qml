import QtQuick
import Quickshell.Services.SystemTray

import qs.Components
import qs.Config
import qs.Modules.Bar.Popups

MContainer {
    id: root
    color: "transparent"

    required property TrayPopup trayPopup

    Item {
        implicitWidth: trayIcon.implicitWidth
        implicitHeight: trayIcon.implicitHeight

        MIcon {
            id: trayIcon
            size: MIcons.l
            fromSource: "tray.svg"
            overlay: true
            color: SystemTray.items.values.length > 0 ? MColors.base05 : MColors.base03
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                root.trayPopup.requestedVisible = !root.trayPopup.requestedVisible;
            }
        }
    }
}
