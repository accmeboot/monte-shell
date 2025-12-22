import QtQuick
import Quickshell

import qs.Modules.Bar
import qs.Components

Scope {
    Variants {
        model: Quickshell.screens

        delegate: Item {
            id: rootItem
            required property var modelData

            Bar {
                id: barPanel
                screen: rootItem.modelData
            }

            MOverlay {
                id: overlayPanel
            }
        }
    }
}
