pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

import qs.Config

Item {
    id: root

    required property Item source

    readonly property int blurMax: MShadow.blurMax
    readonly property real shadowBlur: MShadow.shadowBlur

    readonly property int extraSpace: blurMax * shadowBlur

    layer.enabled: true
    layer.effect: MultiEffect {
        source: root.source
        shadowEnabled: true
        blurMax: root.blurMax
        shadowBlur: root.shadowBlur
        shadowOpacity: MShadow.shadowOpacity
        shadowColor: MShadow.shadowColor
        shadowHorizontalOffset: MShadow.shadowHorizontalOffset
        shadowVerticalOffset: MShadow.shadowVerticalOffset
        autoPaddingEnabled: true
    }
}
