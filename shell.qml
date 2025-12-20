import QtQuick
import Quickshell

import qs.Modules.Bar

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
        }
    }
}
