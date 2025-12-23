pragma ComponentBehavior: Bound

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
                id: contentColumn

                spacing: MSpacing.xs

                RowLayout {
                    id: sinkSliderRow
                    spacing: MSpacing.s

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

                Repeater {
                    model: PipewireManager.nodesModel

                    delegate: MContainer {
                        id: sinkNodeItem

                        required property var modelData

                        visible: modelData.isSink && modelData.audio && modelData.nickname

                        color: mouseArea.containsMouse ? MColors.base01 : MColors.base00

                        Item {
                            implicitWidth: sinkSliderRow.implicitWidth
                            implicitHeight: sinkRow.implicitHeight

                            RowLayout {
                                id: sinkRow
                                spacing: MSpacing.s

                                MIcon {
                                    fromSource: "circle-filled.svg"
                                    size: MIcons.s
                                    color: MColors.base0D
                                    overlay: true
                                    opacity: sinkNodeItem.modelData === PipewireManager.defaultSink
                                }

                                Text {
                                    id: sinkText
                                    text: sinkNodeItem.modelData.nickname
                                    color: MColors.base05
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    PipewireManager.setDefaultAudioSink(sinkNodeItem.modelData);
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: MBorder.width
                    Layout.topMargin: MSpacing.xs
                    Layout.bottomMargin: MSpacing.xs
                    color: MColors.base01
                }

                RowLayout {
                    id: sourceSliderRow
                    spacing: MSpacing.s
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

                Repeater {
                    model: PipewireManager.nodesModel

                    delegate: MContainer {
                        id: sourceNodeItem

                        required property var modelData

                        property bool isSource: !modelData.isSink && !modelData.isStream

                        visible: isSource && modelData.audio && modelData.nickname

                        color: sourceMouseArea.containsMouse ? MColors.base01 : MColors.base00

                        Item {
                            implicitWidth: sourceSliderRow.implicitWidth
                            implicitHeight: sourceRow.implicitHeight

                            RowLayout {
                                id: sourceRow
                                spacing: MSpacing.s

                                MIcon {
                                    fromSource: "circle-filled.svg"
                                    size: MIcons.s
                                    color: MColors.base0D
                                    overlay: true
                                    opacity: sourceNodeItem.modelData === PipewireManager.defaultSource
                                }

                                Text {
                                    text: sourceNodeItem.modelData.nickname
                                    color: MColors.base05
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                id: sourceMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    PipewireManager.setDefaultAudioSource(sourceNodeItem.modelData);
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: MBorder.width
                    Layout.topMargin: MSpacing.xs
                    Layout.bottomMargin: MSpacing.xs
                    color: MColors.base01
                }

                MContainer {
                    color: settingsMouseArea.containsMouse ? MColors.base01 : MColors.base00
                    Item {
                        implicitWidth: sourceSliderRow.implicitWidth
                        implicitHeight: settingsText.implicitHeight
                        MText {
                            id: settingsText
                            text: "SETTINGS"
                            font.bold: true
                        }
                        MouseArea {
                            id: settingsMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                //TODO: use the command from settings
                                Quickshell.execDetached(["sh", "-c", "wezterm start -e wiremix -v output"]);
                                root.visible = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
