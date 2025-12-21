import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Config
import qs.Managers

MContainer {
    id: root

    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    property var activeWindow: NiriManager.getActiveWindow()

    visible: Boolean(activeWindow)

    Item {
        id: container

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        property bool isTruncated: implicitWidth > root.width

        RowLayout {
            id: content
            spacing: MSpacing.xs
            x: container.isTruncated && mouseArea.containsMouse ? scrollAnim.offset : 0

            MIcon {
                id: icon
                size: MIcons.l
                source: root.activeWindow?.app_id ?? ""
            }
            MText {
                text: root.activeWindow?.title ?? ""
                elide: Text.ElideRight
                Layout.preferredWidth: {
                    var textWidthCalculated = root.maxWidth - icon.size - root.paddingHorizontal * 2 - content.spacing;

                    return mouseArea.containsMouse ? implicitWidth : Math.min(implicitWidth, textWidthCalculated);
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                if (!containsMouse) {
                    scrollAnim.stop();
                    scrollAnim.offset = 0;
                }
            }
        }

        SequentialAnimation {
            id: scrollAnim
            running: container.isTruncated && mouseArea.containsMouse
            loops: Animation.Infinite

            property real offset: 0

            PauseAnimation {
                duration: 200
            }

            NumberAnimation {
                target: scrollAnim
                property: "offset"
                from: 0
                to: -(content.implicitWidth - container.width)
                duration: 2000
            }

            PauseAnimation {
                duration: 1000
            }

            NumberAnimation {
                target: scrollAnim
                property: "offset"
                to: 0
                duration: 2000
            }
        }
    }
}
