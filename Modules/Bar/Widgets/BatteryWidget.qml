import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.Components
import qs.Config

MContainer {
    id: root

    color: MColors.base01

    property UPowerDevice device: UPower.displayDevice
    property int percentage: device ? device.percentage * 100 : null

    visible: device.isPresent

    RowLayout {
        spacing: MSpacing.xs
        MIcon {
            size: MIcons.l
            fromSource: root.getIcon()
            color: MColors.base05
            overlay: true
        }
        MText {
            text: root.percentage + "%"
        }
    }

    function getIcon() {
        switch (device.state) {
        case UPowerDeviceState.Discharging:
        case UPowerDeviceState.PendingDischarge:
        case UPowerDeviceState.Empty:
            return getIconByPercantage();
        case UPowerDeviceState.Unknown:
        case UPowerDeviceState.PendingCharge:
        case UPowerDeviceState.FullyCharged:
            return "battery-plugged.svg";
        case UPowerDeviceState.Charging:
            return "battery-charging.svg";
        }
    }

    function getIconByPercantage() {
        switch (true) {
        case percentage >= 80:
            return "battery-full.svg";
        case percentage >= 60:
            return "battery-good.svg";
        case percentage >= 40:
            return "battery-low.svg";
        default:
            return "battery-empty.svg";
        }
    }
}
