pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs.Components
import qs.Managers
import qs.Config

PanelWindow {
    id: root

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Ignore

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    visible: Boolean(NotificationManager.activeList.count)

    //TODO: get that from settings
    property int maxVisible: 3
    property int notificationWidth: 300

    anchors {
        top: true
        right: true
    }

    MShadowEffect {
        id: shadow
        source: container
        anchors.fill: container
    }

    Item {
        id: container
        implicitWidth: content.implicitWidth + concaveTopLeft.implicitWidth
        implicitHeight: content.implicitHeight + concaveBottomRight.implicitHeight

        anchors.right: parent.right

        MConcaveCorner {
            id: concaveTopLeft
            location: "top-left"
            anchors.top: parent.top
            anchors.left: parent.left
        }

        MConcaveCorner {
            id: concaveBottomRight
            location: "bottom-right"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        MContainer {
            id: content

            topLeftRadius: 0
            topRightRadius: 0
            bottomRightRadius: 0

            anchors.right: parent.right

            Item {
                id: contentItem

                implicitWidth: root.notificationWidth
                implicitHeight: nContainer.implicitHeight + stackItem.height

                Item {
                    id: stackItem

                    property int shrinkWidthOffset: MSpacing.m
                    property int cardYOffset: MSpacing.m
                    property int count: {
                        if (NotificationManager.activeList.count === 0)
                            return 0;
                        return Math.min(NotificationManager.activeList.count - 1, root.maxVisible);
                    }

                    property int cardHeight: 20

                    implicitWidth: nContainer.implicitWidth
                    implicitHeight: {
                        if (count > 0) {
                            return cardYOffset * count;
                        }
                        return 0;
                    }

                    anchors.bottom: nContainer.top

                    Repeater {
                        model: stackItem.count

                        delegate: Rectangle {
                            required property int index

                            width: stackItem.implicitWidth - (stackItem.count - index + 1) * stackItem.shrinkWidthOffset
                            height: stackItem.cardHeight

                            color: MColors.base02
                            radius: MBorder.radius

                            y: index * stackItem.cardYOffset

                            z: -(stackItem.count - index + 1)

                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                MContainer {
                    id: nContainer

                    property int idx: NotificationManager.activeList.count - 1
                    property QtObject notification: NotificationManager.activeList.get(idx) ?? QtObject

                    property bool hasIcon: Boolean(notification?.icon) || Boolean(notification?.image)

                    color: MColors.base01

                    y: stackItem.implicitHeight

                    z: 1

                    Item {
                        implicitWidth: nRow.implicitWidth
                        implicitHeight: nRow.implicitHeight

                        MIcon {
                            fromSource: "cross.svg"
                            overlay: true
                            color: MColors.base04
                            size: MIcons.l
                            anchors.top: parent.top
                            anchors.right: parent.right

                            MouseArea {
                                id: closeMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true

                                onClicked: {
                                    NotificationManager.dismissOrExpireNotification(nContainer.notification.id);
                                }
                            }
                        }

                        RowLayout {
                            id: nRow
                            spacing: MSpacing.s

                            MIcon {
                                id: notificationIcon
                                fromSource: nContainer?.hasIcon ? "" : "notification.svg"
                                source: nContainer.hasIcon ? nContainer.notification?.icon || nContainer.notification?.image : ""
                                color: nContainer.notification?.hasIcon ? "transparent" : MColors.base05
                                overlay: !nContainer.hasIcon
                                size: MIcons.xxxl
                            }
                            ColumnLayout {
                                id: nColumn
                                spacing: MSpacing.xs

                                property int availableWidth: contentItem.width - notificationIcon.width - nContainer.paddingHorizontal * 2 - nRow.spacing

                                MText {
                                    text: nContainer.notification?.appName + "<font color='" + MColors.base04 + "'>&#8194;" + root.getTime(nContainer.notification?.timestamp) + "</font>"
                                    color: {
                                        switch (nContainer.notification?.urgency) {
                                        case NotificationUrgency.Critical:
                                            return MColors.base08;
                                        case NotificationUrgency.Normal:
                                            return MColors.base0A;
                                        default:
                                            return MColors.base0C;
                                        }
                                    }
                                    wrapMode: Text.Wrap
                                    font.bold: true
                                    textFormat: Text.StyledText
                                    Layout.preferredWidth: Math.max(nColumn.availableWidth, width)
                                }
                                MText {
                                    text: nContainer.notification?.title ?? ""
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 1
                                    elide: Text.ElideRight
                                    font.bold: true
                                    Layout.preferredWidth: Math.max(nColumn.availableWidth, width)
                                }
                                MText {
                                    text: nContainer.notification?.body ?? ""
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    textFormat: Text.StyledText
                                    Layout.preferredWidth: Math.max(nColumn.availableWidth, width)
                                }

                                Item {
                                    visible: Boolean(nContainer.notification?.actions?.count)
                                    implicitHeight: MSpacing.xs
                                }

                                RowLayout {
                                    id: actionsRow
                                    spacing: MSpacing.xs

                                    Repeater {
                                        model: nContainer.notification?.actions
                                        delegate: MContainer {
                                            id: action
                                            required property var modelData

                                            color: MColors.base0A

                                            Item {
                                                implicitWidth: actionText.width
                                                implicitHeight: actionText.height

                                                MText {
                                                    id: actionText
                                                    color: MColors.base00
                                                    text: action.modelData.text
                                                    elide: Text.ElideRight
                                                    width: Math.min(implicitWidth, 100)
                                                    textFormat: Text.StyledText
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    cursorShape: Qt.PointingHandCursor
                                                    hoverEnabled: true

                                                    onClicked: {
                                                        NotificationManager.invokeAction(nContainer.notification.id, action.modelData.id);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function getTime(timestamp) {
        var date = new Date(timestamp);
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');

        return hours + ":" + minutes;
    }
}
