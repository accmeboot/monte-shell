import Quickshell
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

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    color: "transparent"

    anchor {
        window: anchorWindow
        rect.x: widget.x + (widget.width - content.width) / 2
        rect.y: contentHeight
    }

    visible: false

    Connections {
        target: OverlayManager

        function onClicked() {
            root.visible = false;
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

            ColumnLayout {
                RowLayout {
                    MIcon {
                        size: MIcons.l
                        fromSource: "speaker.svg"
                        color: MColors.base05
                        overlay: true
                    }
                    MSlider {
                        id: sinkVolumeSlider
                        value: PipewireManager.sinkVolume
                        onMoved: {
                            PipewireManager.setSinkVolume(Math.round(value));
                        }
                    }
                }
                RowLayout {
                    MIcon {
                        size: MIcons.l
                        fromSource: "microphone.svg"
                        color: MColors.base05
                        overlay: true
                    }
                    MSlider {
                        id: sourceVolumeSlider
                        value: PipewireManager.sourceVolume
                        onMoved: {
                            PipewireManager.setSourceVolume(Math.round(value));
                        }
                    }
                }
            }
        }
    }
}
