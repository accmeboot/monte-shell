import QtQuick
import QtQuick.Layouts

import qs.Managers
import qs.Config
import qs.Components

MContainer {
    id: root
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.xs
        MIcon {
            size: MIcons.l
            fromSource: root.getIcon()
            color: MColors.base05
            overlay: true
        }
    }

    function getIcon() {
        switch (NetworkManager.connectionType) {
        case "wifi":
            return getWifiIcon();
        default:
            return getEthernetIcon();
        }
    }

    function getWifiIcon() {
        if (!NetworkManager.isConnected)
            return "wifi-disconnected.svg";

        switch (true) {
        case NetworkManager.signalStrength >= 75:
            return "wifi-100.svg";
        case NetworkManager.signalStrength >= 50:
            return "wifi-75.svg";
        case NetworkManager.signalStrength >= 25:
            return "wifi-50.svg";
        default:
            return "wifi-25.svg";
        }
    }

    function getEthernetIcon() {
        return NetworkManager.isConnected ? "ethernet.svg" : "ethernet-disconnected.svg";
    }
}
