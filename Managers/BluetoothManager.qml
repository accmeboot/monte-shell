pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    property var devices: Bluetooth.devices

    property string currentDeviceName: {
        var device = devices.values.find(d => d.connected);
        return device?.name ?? null;
    }

    property bool isDeviceInUse: {
        return devices.values.some(device => {
            return device.connected;
        });
    }
}
