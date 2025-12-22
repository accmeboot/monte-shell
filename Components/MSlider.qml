import QtQuick
import QtQuick.Controls

import qs.Config

Slider {
    id: root
    from: 0
    to: 100

    value: 0.5

    implicitWidth: 150

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2

        implicitWidth: root.implicitWidth
        implicitHeight: MIcons.m

        width: root.availableWidth
        height: implicitHeight
        radius: MBorder.radius
        color: MColors.base02

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            color: MColors.base0D
            radius: MBorder.radius
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2

        implicitWidth: MIcons.m
        implicitHeight: MIcons.m
        radius: MBorder.radius

        color: MColors.base0D
    }
}
