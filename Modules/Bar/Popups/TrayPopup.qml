pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Managers
import qs.Config

PopupWindow {
    id: root

    required property Item widget
    required property PanelWindow anchorWindow
    required property int contentHeight

    property bool requestedVisible: false

    property int count: SystemTray.items.values.length

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    color: "transparent"

    anchor {
        window: anchorWindow
        rect.x: widget.x + widget.width - content.width
        rect.y: contentHeight
    }

    visible: requestedVisible && count > 0

    Connections {
        target: OverlayManager

        function onClicked() {
            root.requestedVisible = false;
        }
    }

    onVisibleChanged: {
        OverlayManager.set(visible);
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

            GridLayout {
                columns: root.count < 3 ? root.count : 3

                columnSpacing: MSpacing.l
                rowSpacing: MSpacing.l

                Repeater {
                    model: SystemTray.items
                    delegate: Item {
                        id: tryaIconItem
                        required property SystemTrayItem modelData

                        implicitWidth: itemIcon.implicitWidth
                        implicitHeight: itemIcon.implicitHeight

                        MIcon {
                            id: itemIcon
                            size: MIcons.xxl
                            source: tryaIconItem.modelData.icon
                        }

                        QsMenuAnchor {
                            id: menuAnchor
                            menu: tryaIconItem.modelData.menu

                            anchor.window: root
                            anchor.rect.width: itemIcon.width
                            anchor.rect.height: 0
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton) {
                                    tryaIconItem.modelData.activate();
                                } else if (mouse.button === Qt.RightButton) {
                                    menuAnchor.anchor.rect.x = tryaIconItem.x;
                                    menuAnchor.anchor.rect.y = tryaIconItem.y + tryaIconItem.height;

                                    menuAnchor.open();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
