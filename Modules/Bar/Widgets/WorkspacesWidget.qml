import QtQuick
import QtQuick.Layouts

import qs.Managers
import qs.Components
import qs.Config

MContainer {
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.s

        Repeater {
            model: NiriManager.workspaces

            delegate: Rectangle {
                required property var modelData

                property bool isActive: modelData.is_active
                property color hoverColor: {
                    Qt.rgba(MColors.base03.r, MColors.base03.g, MColors.base03.b, 0.5);
                }

                width: isActive ? MIcons.xxxl : MIcons.l
                height: MIcons.l

                radius: MIcons.l * 2

                color: {
                    if (isActive) {
                        return MColors.base0D;
                    }

                    return mouseArea.containsMouse ? Qt.rgba(MColors.base03.r, MColors.base03.g, MColors.base03.b, 0.5) : MColors.base03;
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        NiriManager.switchToWorkspace(parent.modelData.idx);
                    }
                }
            }
        }
    }
}
