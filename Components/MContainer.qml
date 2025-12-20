import QtQuick
import Quickshell.Widgets

import qs.Config

Rectangle {
    id: root

    property int paddingHorizontal: MSpacing.s
    property int paddingVertical: MSpacing.s

    property int maxWidth: -1

    color: MColors.base00
    radius: MBorder.radius

    clip: maxWidth > 0

    implicitWidth: {
        var contentWidth = manager.implicitWidth;

        if (maxWidth > 0) {
            return Math.min(contentWidth, maxWidth);
        }
        return contentWidth;
    }

    implicitHeight: manager.implicitHeight

    MarginWrapperManager {
        id: manager
        leftMargin: root.paddingHorizontal
        rightMargin: root.paddingHorizontal
        topMargin: root.paddingVertical
        bottomMargin: root.paddingVertical
    }
}
