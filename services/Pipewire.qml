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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire


//  .-------------------------.
//  | .---------------------. |
//  | |  Pipewire Service   | |
//  | `---------------------' |
//  `-------------------------'

Item {
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
    
    // Mapeo
    readonly property var availableSinks: nodesMap.sinks
    readonly property var availableSources: nodesMap.sources

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    // Audio
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property int volumePercent: Math.round(volume * 100)
    readonly property bool muted: !!sink?.audio?.muted
    readonly property string deviceName: sink ? sink.description : "No device"
    
    // Microfono
    readonly property real micVolume: source?.audio?.volume ?? 0.0
    readonly property int micVolumePercent: Math.round(micVolume * 100)
    readonly property bool micMuted: !!source?.audio?.muted


    // Asignamiento de Iconos

    readonly property string icon: {
        if (muted) return "󰖁"
        if (volumePercent === 0) return "󰝟"
        if (volumePercent < 25) return "󰕿"
        if (volumePercent < 50) return "󰖀"
        if (volumePercent < 75) return "󰕾"
        return "󰕾"
    }

    readonly property string iconMic: {
        if (micMuted) return "󰍭"
        return "󰍬"
    }
    
    // Tracker de Nodos
    PwObjectTracker {
        objects: [...root.availableSinks, ...root.availableSources]
    }
    
    // Funciones de Audio

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
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = !sink.audio.muted
        }
    }

    // Funciones de Microfono.

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