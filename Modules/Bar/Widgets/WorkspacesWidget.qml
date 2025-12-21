import QtQuick
import QtQuick.Layouts

import qs.Managers
import qs.Components
import qs.Config

MContainer {
    id: root
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.s

        Repeater {
            model: NiriManager.workspaces

            delegate: Rectangle {
                id: workspace
                required property var modelData

                property bool isActive: modelData.is_active
                property color hoverColor: {
                    Qt.rgba(MColors.base05.r, MColors.base05.g, MColors.base05.b, 0.5);
                }

                width: isActive ? MIcons.xxxl : MIcons.l
                height: MIcons.l

                radius: MBorder.radius

                color: isActive ? MColors.base0D : MColors.base01

                MText {
                    anchors.centerIn: parent
                    text: workspace.modelData.idx
                    color: {
                        if (workspace.isActive) {
                            return MColors.base00;
                        }

                        return mouseArea.containsMouse ? workspace.hoverColor : MColors.base05;
                    }
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
