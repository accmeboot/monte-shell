import QtQuick
import Quickshell

import qs.Managers

PanelWindow {
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    visible: OverlayManager.visible

    MouseArea {
        anchors.fill: parent
        enabled: true
        z: 0
        onClicked: {
            OverlayManager.clicked();
            OverlayManager.set(false);
        }
    }
}
