//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝
//                          MarioRRom's Aetheris Shell
//                 https://github.com/MarioRRom/aetheris-shell
//===========================================================================


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire


//  .-------------------------.
//  | .---------------------. |
//  | |  Pipewire Service   | |
//  | `---------------------' |
//  `-------------------------'

QtObject {
    id: root

    // Pipewire Nodes
    readonly property var allNodes: Pipewire.nodes
    readonly property var nodesMap: allNodes.values.reduce((acc, node) => {
        if (!node.isStream) {
            if (node.isSink)
                acc.sinks.push(node);
            else if (node.audio)
                acc.sources.push(node);
        }
        return acc;
    }, {
        sources: [],
        sinks: []
    })

    // Mapping
    readonly property var availableSinks: nodesMap.sinks
    readonly property var availableSources: nodesMap.sources

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    // Audio
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property int volumePercent: Math.round(volume * 100)
    readonly property bool muted: !!sink?.audio?.muted
    readonly property string deviceName: sink ? sink.description : "No device"

    // Microphone
    readonly property real micVolume: source?.audio?.volume ?? 0.0
    readonly property int micVolumePercent: Math.round(micVolume * 100)

    // Icons
    readonly property string icon: {
        if (muted) return "󰝟"
        if (volumePercent <= 0) return "󰝟"
        if (volumePercent <= 33) return "󰕿"
        if (volumePercent <= 66) return "󰖀"
        return "󰕾"
    }

    readonly property string iconMic: {
        if (source?.audio?.muted) return "󰍭"
        if (micVolumePercent <= 0) return "󰍭"
        if (micVolumePercent <= 33) return "󰍬"
        return "󰍬"
    }

    // Node Tracker
    property PwObjectTracker nodeTracker: PwObjectTracker {
        objects: [...root.availableSinks, ...root.availableSources]
    }
    // Audio Functions
    function setVolume(vol) {
        if (sink?.ready && sink?.audio) {
            var newVol = Math.max(0.0, Math.min(1.5, vol))
            sink.audio.volume = newVol
        }
    }

    function setVolumePercent(percent) { setVolume(percent / 100.0) }

    function incrementVolume(stepPercent = 5) {
        if (volumePercent != 100) {
            setVolumePercent(volumePercent + stepPercent)
        }
    }

    function decrementVolume(stepPercent = 5) { setVolumePercent(volumePercent - stepPercent) }

    function toggleMute() {
        if (sink && sink.ready && sink.audio) {
            sink.audio.muted = !sink.audio.muted
        }
    }

    // Microphone Functions

    function setVolumeMic(vol) {
        if (source?.ready && source?.audio) {
            var newVol = Math.max(0.0, Math.min(1.5, vol))
            source.audio.volume = newVol
        }
    }

    function setVolumeMicPercent(percent) { setVolumeMic(percent / 100.0) }

    function incrementVolumeMic(stepPercent = 5) {
        if (micVolumePercent != 100) {
        setVolumeMicPercent(micVolumePercent + stepPercent)
        }
    }

    function decrementVolumeMic(stepPercent = 5) { setVolumeMicPercent(micVolumePercent - stepPercent) }

    function toggleMic() {
        if (source && source.ready && source.audio) {
            source.audio.muted = !source.audio.muted
        }
    }
}