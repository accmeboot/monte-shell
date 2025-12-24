import Quickshell
import QtQuick

import qs.Components
import qs.Config

MContainer {
    id: root
    color: "transparent"

    Item {
        implicitWidth: launcherIcon.implicitWidth
        implicitHeight: launcherIcon.implicitHeight

        MIcon {
            id: launcherIcon
            size: MIcons.l
            fromSource: "find.svg"
            overlay: true
            color: MColors.base05
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                Quickshell.execDetached(["sh", "-c", "qs -c monte-shell ipc call launcher toggle"]);
            }
        }
    }
}
