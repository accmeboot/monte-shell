import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Config
import qs.Modules.Bar.Widgets
import qs.Modules.Bar.Popups

PanelWindow {
    id: root

    color: "transparent"

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    exclusiveZone: container.implicitHeight

    anchors {
        top: true
    }

    MShadowEffect {
        id: shadow
        source: container
        anchors.fill: container
    }

    Item {
        id: container
        property int concavesWidth: concaveTopLeft.implicitWidth + concaveTopRight.implicitWidth

        implicitWidth: content.implicitWidth + concavesWidth
        implicitHeight: content.implicitHeight

        anchors.horizontalCenter: parent.horizontalCenter

        MConcaveCorner {
            id: concaveTopLeft
            location: "top-left"
            anchors.top: parent.top
            anchors.left: parent.left
        }

        MConcaveCorner {
            id: concaveTopRight
            location: "top-right"
            anchors.top: parent.top
            anchors.right: parent.right
        }

        MContainer {
            id: content
            topLeftRadius: 0
            topRightRadius: 0

            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                WorkspacesWidget {}
                Item {
                    id: windowContainer
                    implicitWidth: 250
                    implicitHeight: window.implicitHeight
                    WindowWidget {
                        id: window
                        maxWidth: windowContainer.implicitWidth
                    }
                }
                PipewireWidget {
                    id: pipewireWidget
                    pipewirePopup: pipewirePopup
                }
                NetworkWidget {}
                BluetoothWidget {}
                BatteryWidget {}
                ClockWidget {}
            }
        }
    }

    PipewirePopup {
        id: pipewirePopup
        widget: pipewireWidget
        anchorWindow: root
        contentHeight: content.height
    }
}
