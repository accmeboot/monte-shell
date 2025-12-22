pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    signal clicked

    property bool visible: false

    function set(value) {
        visible = value;
    }
}
