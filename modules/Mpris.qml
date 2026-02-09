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
import Quickshell.Services.Mpris


//  .-------------------------.
//  | .---------------------. |
//  | |    Mpris Service    | |
//  | `---------------------' |
//  `-------------------------'

QtObject {
    id: mediaPlayer
    
    // Acceso al reproductor activo (o nulo si no hay ninguno)
    readonly property var activePlayer: selectedPlayer ?? (Mpris.players.values[0] ?? null)
    readonly property var casseteImg: Qt.resolvedUrl("../assets/cassette.png")

    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Player Activo    | |
    //  | `---------------------' |
    //  `-------------------------'

    // Obtención de Metadatos (Wiki: trackArtist > trackArtists)
    property string title: activePlayer?.trackTitle || "No Title"
    property string artist: activePlayer?.trackArtist || "No Artist"
    property string artUrl: activePlayer?.trackArtUrl || casseteImg
    property string player: activePlayer?.identity ?? "No Player"
    
    // Estados del Reproductor Activo
    readonly property bool status: Mpris.players.values.length > 0
    readonly property bool isPaused: activePlayer?.playbackState === MprisPlaybackState.Paused

    // Capacidades y Estados de Control (Wiki: canSeek, positionSupported)
    readonly property bool canTogglePlaying: activePlayer?.canTogglePlaying ?? false
    readonly property bool canGoNext: activePlayer?.canGoNext ?? false
    readonly property bool canGoPrevious: activePlayer?.canGoPrevious ?? false
    readonly property bool canSeek: activePlayer?.canSeek ?? false
    readonly property bool positionSupported: activePlayer?.positionSupported ?? false

    readonly property bool canShuffle: activePlayer?.shuffleSupported ?? false
    readonly property bool isShuffled: activePlayer?.shuffle ?? false

    readonly property bool canRepeat: activePlayer?.loopSupported ?? false
    readonly property int isRepeating: activePlayer?.loopState ?? MprisLoopState.None

    readonly property bool canVolume: activePlayer?.volumeSupported ?? false
    property real volume: activePlayer?.volume ?? 1.0

    // Tiempos del Reproductor Activo
    property real position: 0
    property real duration: 0

    // Actualizador de posición (Wiki: Timer + positionChanged())
    property var progressTimer: Timer {
        interval: 1000
        repeat: true
        running: activePlayer !== null && activePlayer.playbackState === MprisPlaybackState.Playing
        onTriggered: {
            if (mediaPlayer.activePlayer) {
                mediaPlayer.activePlayer.positionChanged(); // Despierta el valor
                mediaPlayer.position = mediaPlayer.activePlayer.position;
            }
        }
    }

    property var activePlayerConnections: Connections {
        target: mediaPlayer.activePlayer
        ignoreUnknownSignals: true 

        // Wiki: postTrackChanged es más seguro para info actualizada
        function onPostTrackChanged() {
            if (mediaPlayer.activePlayer) {
                mediaPlayer.duration = mediaPlayer.activePlayer.length;
                mediaPlayer.position = mediaPlayer.activePlayer.position;
            }
        }

        function onPlaybackStateChanged() {
            if (mediaPlayer.activePlayer) {
                mediaPlayer.position = mediaPlayer.activePlayer.position;
            }
        }

        function onVolumeChanged() {
            if (mediaPlayer.activePlayer) {
                mediaPlayer.volume = mediaPlayer.activePlayer.volume;
            }
        }
    }

    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Otros Players    | |
    //  | `---------------------' |
    //  `-------------------------'

    // Propiedad para forzar un reproductor específico
    property var selectedPlayer: null

    // Lista de todos los reproductores
    readonly property var allPlayers: Mpris.players.values
    property int lastPlayerCount: 0

    // Lógica de gestión de reproductores y auto-cambio
    property var playerConnections: Connections {
        target: Mpris.players
        function onValuesChanged() {
            const currentPlayers = Mpris.players.values;
            const currentCount = currentPlayers.length;

            if (currentCount > mediaPlayer.lastPlayerCount) {
                mediaPlayer.selectedPlayer = currentPlayers[currentCount - 1];
            }
            
            if (mediaPlayer.selectedPlayer !== null) {
                let exists = false;
                for (let i = 0; i < currentCount; i++) {
                    if (currentPlayers[i] === mediaPlayer.selectedPlayer) {
                        exists = true; break;
                    }
                }
                if (!exists) mediaPlayer.selectedPlayer = null;
            }

            mediaPlayer.lastPlayerCount = currentCount;
            
            // Sincronización al cambiar de player
            if (mediaPlayer.activePlayer) {
                mediaPlayer.duration = mediaPlayer.activePlayer.length;
                mediaPlayer.position = mediaPlayer.activePlayer.position;
                mediaPlayer.volume = mediaPlayer.activePlayer.volume;
            }
        }
    }

    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Funcionalidades   | |
    //  | `---------------------' |
    //  `-------------------------'

    function formatTime(totalSeconds) {
        if (isNaN(totalSeconds) || totalSeconds < 0) return "00:00";
        const minutes = Math.floor(totalSeconds / 60);
        const seconds = Math.floor(totalSeconds % 60);
        return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
    
    function playpause() {
        // Wiki: togglePlaying() es más directo que play/pause manual
        if (activePlayer && canTogglePlaying) activePlayer.togglePlaying();
    }

    function next() { if (canGoNext) activePlayer.next(); }
    function previous() { if (canGoPrevious) activePlayer.previous(); }

    function shuffle() {
        if (activePlayer && canShuffle) activePlayer.shuffle = !activePlayer.shuffle;
    }

    function repeat() {
        if (!activePlayer || !canRepeat) return;
        const states = [MprisLoopState.None, MprisLoopState.Playlist, MprisLoopState.Track];
        let nextIndex = (states.indexOf(activePlayer.loopState) + 1) % states.length;
        activePlayer.loopState = states[nextIndex];
    }

    function setVolume(val) {
        if (activePlayer && canVolume) {
            activePlayer.volume = val;
            mediaPlayer.volume = val;
        }
    }

    // Nueva función para alterar el tiempo (Seek)
    function setPosition(ratio) {
        if (activePlayer && canSeek && positionSupported) {
            let newPos = ratio * duration;
            activePlayer.position = Math.max(0, Math.min(newPos, duration));
            mediaPlayer.position = activePlayer.position;
        }
    }

    function selectPlayer(player) { selectedPlayer = player; }

    Component.onCompleted: {
        lastPlayerCount = Mpris.players.values.length;
        if (activePlayer) {
            duration = activePlayer.length;
            position = activePlayer.position;
            volume = activePlayer.volume;
        }
    }
}