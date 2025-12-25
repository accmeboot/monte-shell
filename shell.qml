//@ pragma UseQApplication
import QtQuick
import Quickshell

import qs.Modules.Bar
import qs.Modules.Launcher
import qs.Modules.Notifications
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

            Launcher {
                id: launcherPanel
                screen: rootItem.modelData
            }

            Notifications {
                id: notificationsPanel
                screen: rootItem.modelData
            }

            MOverlay {
                id: overlayPanel
            }
        }
    }
}
