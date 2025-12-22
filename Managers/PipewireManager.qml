pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property PwNode defaultSink: Pipewire.ready ? Pipewire.defaultAudioSink : null
    property PwNode defaultSource: Pipewire.ready ? Pipewire.defaultAudioSource : null

    property var nodesModel: Pipewire.nodes

    PwObjectTracker {
        objects: [root.defaultSink, root.defaultSource]
    }

    property int sinkVolume: {
        if (defaultSink && defaultSink.audio) {
            return Math.round(defaultSink.audio.volume * 100);
        }
        return 0;
    }

    property int sourceVolume: {
        if (defaultSource && defaultSource.audio) {
            return Math.round(defaultSource.audio.volume * 100);
        }
        return 0;
    }

    property bool isMuted: {
        return defaultSink && defaultSink.audio ? defaultSink.audio.muted : false;
    }

    property string deviceName: defaultSink ? defaultSink.nickname : "none"

    function setSinkVolume(vol) {
        if (defaultSink && defaultSink.audio) {
            defaultSink.audio.volume = vol / 100.0;
        }
    }

    function setSourceVolume(vol) {
        if (defaultSource && defaultSource.audio) {
            defaultSource.audio.volume = vol / 100.0;
        }
    }

    function toggleMute() {
        if (defaultSink && defaultSink.audio) {
            defaultSink.audio.muted = !defaultSink.audio.muted;
        }
    }

    function setDefaultAudioSink(node) {
        if (Pipewire.ready && node && node.isSink) {
            Pipewire.preferredDefaultAudioSink = node;
        }
    }

    function setDefaultAudioSource(node) {
        var isSource = !node.isSink && !node.isStream;

        if (Pipewire.ready && node && isSource) {
            Pipewire.preferredDefaultAudioSource = node;
        }
    }
}
