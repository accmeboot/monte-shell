import Quickshell
import QtQuick

import qs.Components

MContainer {
    color: "transparent"

    MText {
        text: Qt.formatDateTime(systemClock.date, "dddd hh:mm")
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
