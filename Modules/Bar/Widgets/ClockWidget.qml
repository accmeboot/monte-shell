import Quickshell
import QtQuick

import qs.Components
import qs.Config

MContainer {
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    MText {
        text: Qt.formatDateTime(systemClock.date, "dddd hh:mm")
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
