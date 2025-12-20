import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Config

MContainer {
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.xs
        MIcon {
            size: MIcons.l
            fromSource: "calendar.svg"
            color: MColors.base05
        }
        MText {
            text: Qt.formatDateTime(systemClock.date, "dddd hh:mm")
        }
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
