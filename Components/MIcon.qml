import QtQuick
import Qt5Compat.GraphicalEffects

import qs.Config

Item {
    property string source
    property color color
    property string fromSource

    property int size: MIcons.xxl

    implicitWidth: size
    implicitHeight: size

    Image {
        id: img
        anchors.fill: parent
        source: {
            if (parent.fromSource) {
                return `../assets/${parent.fromSource}`;
            }

            if (parent.source.startsWith("/")) {
                return `file://${parent.source}`;
            }

            return `image://icon/parent.source`;
        }
        width: parent.size
        height: parent.size
        sourceSize: Qt.size(parent.size, parent.size)
        visible: false
    }

    ColorOverlay {
        visible: Boolean(parent.color)
        anchors.fill: parent
        source: img
        color: parent.color
    }
}
