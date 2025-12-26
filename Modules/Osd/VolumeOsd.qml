pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts

import qs.Components
import qs.Managers
import qs.Config

PanelWindow {
    id: root

    color: "transparent"

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    visible: false

    exclusionMode: ExclusionMode.Normal
    WlrLayershell.layer: WlrLayer.Overlay

    Loader {
        id: loader
        active: Boolean(PipewireManager.defaultSink)
        sourceComponent: Component {
            id: loaderComponent
            Connections {
                target: PipewireManager.defaultSink.audio

                function onVolumeChanged() {
                    loader.onConnectionUpdate();
                }

                function onMutedChanged() {
                    loader.onConnectionUpdate();
                }
            }
        }

        function onConnectionUpdate() {
            root.visible = true;
            hideTimer.restart();
        }

        Timer {
            id: hideTimer
            interval: 1000
            onTriggered: root.visible = false
        }
    }

    anchors {
        right: true
    }

    MShadowEffect {
        id: shadow
        source: container
        anchors.fill: container
    }

    Item {
        id: container
        property int concavesHeight: concaveTopRight.implicitHeight + concaveBottomRight.implicitHeight

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight + concavesHeight

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        MConcaveCorner {
            id: concaveTopRight
            location: "top-right"
            inverted: true
            anchors.top: parent.top
            anchors.right: parent.right
        }

        MConcaveCorner {
            id: concaveBottomRight
            location: "bottom-right"
            anchors.top: content.bottom
            anchors.right: parent.right
        }

        MContainer {
            id: content

            topRightRadius: 0
            bottomRightRadius: 0

            anchors.verticalCenter: parent.verticalCenter

            ColumnLayout {
                spacing: MSpacing.xs

                MSlider {
                    value: PipewireManager.sinkVolume
                    orientation: Qt.Vertical
                    Layout.alignment: Qt.AlignHCenter
                }

                MIcon {
                    size: MIcons.l
                    fromSource: {
                        if (PipewireManager.isMuted)
                            return "volume-muted.svg";

                        if (PipewireManager.sinkVolume <= 30)
                            return "volume-low.svg";

                        if (PipewireManager.sinkVolume <= 60)
                            return "volume-half.svg";

                        return "volume-full.svg";
                    }
                    color: MColors.base05
                    overlay: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
