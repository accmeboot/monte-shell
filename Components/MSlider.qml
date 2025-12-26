import QtQuick
import QtQuick.Controls

import qs.Config

Slider {
    id: root
    from: 0
    to: 100

    value: 0.5

    implicitWidth: vertical ? MIcons.xxl : 200
    implicitHeight: vertical ? 200 : MIcons.xxl

    background: Rectangle {
        x: root.vertical ? root.leftPadding + root.availableWidth / 2 - width / 2 : root.leftPadding
        y: root.vertical ? root.topPadding : root.topPadding + root.availableHeight / 2 - height / 2

        implicitWidth: root.vertical ? MIcons.s : root.implicitWidth
        implicitHeight: root.vertical ? root.implicitHeight : MIcons.s

        width: root.vertical ? implicitWidth : root.availableWidth
        height: root.vertical ? root.availableHeight : implicitHeight
        radius: MBorder.radius
        color: MColors.base02

        Rectangle {
            anchors.bottom: root.vertical ? parent.bottom : undefined
            width: root.vertical ? parent.width : root.visualPosition * parent.width
            height: root.vertical ? (1 - root.visualPosition) * parent.height : parent.height
            color: MColors.base0D
            radius: MBorder.radius
        }
    }

    handle: Rectangle {
        x: root.vertical ? root.leftPadding + root.availableWidth / 2 - width / 2 : root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.vertical ? root.topPadding + root.visualPosition * (root.availableHeight - height) : root.topPadding + root.availableHeight / 2 - height / 2

        implicitWidth: MIcons.xxl
        implicitHeight: MIcons.xl
        radius: MBorder.radius

        color: MColors.base0A

        MText {
            anchors.centerIn: parent
            text: Math.round(root.value)
            color: MColors.base02
            font.bold: true
        }
    }
}
