import Quickshell
import QtQuick

import qs.Components

PopupWindow {
    id: root

    required property Item widget
    required property PanelWindow anchorWindow
    required property int contentHeight

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    color: "transparent"

    anchor {
        window: anchorWindow
        rect.x: widget.x + (widget.width - root.width) / 2
        rect.y: contentHeight
    }

    visible: false

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

            MText {
                text: "MENU"
            }
        }
    }
}
