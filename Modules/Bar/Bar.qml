import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Config
import qs.Modules.Bar.Widgets

PanelWindow {
    id: root

    color: "transparent"

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    anchors {
        top: true
    }

    MContainer {
        id: content
        paddingVertical: MSpacing.xs

        RowLayout {
            WorkspacesWidget {}
            ClockWidget {}
        }
    }
}
