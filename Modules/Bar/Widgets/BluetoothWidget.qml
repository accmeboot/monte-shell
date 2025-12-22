import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.Managers
import qs.Config
import qs.Components

MContainer {
    paddingVertical: MSpacing.xs
    paddingHorizontal: MSpacing.xs

    color: MColors.base01

    RowLayout {
        spacing: MSpacing.xs
        MIcon {
            size: MIcons.l
            fromSource: {
                if (BluetoothManager.isDeviceInUse)
                    return "bluetooth-connected.svg";

                switch (BluetoothManager.adapter?.state) {
                case BluetoothAdapterState.Enabled:
                    return "bluetooth-on.svg";
                default:
                    return "bluetooth-off.svg";
                }
            }
            color: MColors.base05
            overlay: true
        }
        MText {
            text: BluetoothManager.currentDeviceName ?? BluetoothManager.adapter?.name ?? ""
        }
    }
}
