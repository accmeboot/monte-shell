import QtQuick
import QtQuick.Layouts

import qs.Managers
import qs.Config
import qs.Components
import qs.Modules.Bar.Popups

MContainer {
    id: root

    required property PipewirePopup pipewirePopup

    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    Item {
        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        RowLayout {
            id: content
            spacing: MSpacing.xs
            MIcon {
                size: MIcons.l
                fromSource: {
                    if (PipewireManager.isMuted)
                        return "volume-muted.svg";

                    if (PipewireManager.volume <= 30)
                        return "volume-low.svg";

                    if (PipewireManager.volume <= 60)
                        return "volume-half.svg";

                    return "volume-full.svg";
                }
                color: MColors.base05
                overlay: true
            }
            MText {
                text: PipewireManager.deviceName
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                root.pipewirePopup.visible = !root.pipewirePopup.visible;
            }
        }
    }
}
