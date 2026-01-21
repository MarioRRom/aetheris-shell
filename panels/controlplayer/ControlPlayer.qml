//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝                                                                          
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
//===========================================================================


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// Config
import qs.config
import qs.components
import qs.themes
import qs.modules


PopupWindow {
    id: root

    // Config
    property var bar
    property real globalPos: 0
    property bool volumeControl: false

    // El Radius de la Ventana se Establece desde la Configuración global.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin
    
    property int windowMargin: 10 // Margen interno.
    property int itemRadius: cornerRadius - windowMargin

    implicitWidth: 290
    implicitHeight: 100
    
    anchor.window: bar
    anchor.rect.x: globalPos - (width - 200) // 5px por el margin en el Contenedor Principal.
    anchor.rect.y: bar.height + (globalMargin - 5) //5px por el Margin del Contenedor Principal.
    
    color: "transparent"


    // Contenedor Principal
    Rectangle {
        id: conPlayer
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false
        
        // Sombreado
        Loader {
            anchors.fill: parent
            active: Config.shadows.enabled

            sourceComponent:RectangularShadow {
                anchors.fill: parent
                radius: cornerRadius
                color: Config.shadows.color

                blur: 3
                offset: Qt.vector2d(2, 2)
                spread: 1.0
                cached: true
            }
        }

        // Contenido de la Ventana
        Rectangle {
            anchors.fill: parent
            radius: cornerRadius
            color: ThemeManager.colors.mantle

            // Decoración
            InnerLine {
                anchors.fill: parent
                lineradius: cornerRadius
                linewidth: 2
                linecolor: ThemeManager.colors.surface0
            }

            // Columna principal
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: windowMargin
                spacing: 0


                // Control de Tiempo y Volumen
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.margins: 5
                    spacing: 0


                    // Unified Slider (position + volume)
                    Rectangle {
                        id: mainSliderContainer // Le damos un ID para referenciar el width
                        Layout.fillWidth: true
                        height: 10
                        clip: true
                        radius: 20
                        color: ThemeManager.colors.surface2

                        // Barra de progreso/volumen
                        Rectangle {
                            height: parent.height
                            width: !volumeControl 
                                ? ((Mpris.duration > 0) ? (Mpris.position / Mpris.duration) * parent.width : 0) 
                                : (Mpris.canVolume ? (Mpris.volume * parent.width) : 0)

                            radius: 20
                            color: !volumeControl 
                                ? (Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.sapphire)
                                : ThemeManager.colors.green

                            Behavior on color { ColorAnimation { duration: 200 } }

                            Behavior on width {
                                NumberAnimation {
                                    duration: 650
                                    easing.type: Easing.OutQuint 
                                }
                            }
                        }

                        // MouseArea Única (La mente de Akasha)
                        MouseArea {
                            id: hybridMouseArea
                            anchors.fill: parent
                            
                            // Combinamos las condiciones de poder [cite: 2025-12-29]
                            enabled: volumeControl ? Mpris.canVolume : (Mpris.canSeek && Mpris.positionSupported)
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                            // Propiedad para que la barra no "salte" mientras arrastramos la canción
                            property bool isDraggingPos: false

                            function handleInput(mouseX, isFinalClick) {
                                var ratio = Math.max(0, Math.min(1, mouseX / mainSliderContainer.width));
                                
                                if (volumeControl) {
                                    // EL PODER DEL VOLUMEN: Reactividad total [cite: 2025-12-29]
                                    Mpris.setVolume(ratio);
                                } else {
                                    // LA INFORMACIÓN DE POSICIÓN: Solo al soltar o click inicial
                                    if (isFinalClick) {
                                        Mpris.setPosition(ratio);
                                    }
                                }
                            }

                            onPressed: (mouse) => {
                                if (!volumeControl) isDraggingPos = true;
                                handleInput(mouse.x, true); // El primer click siempre mueve la canción
                            }

                            onPositionChanged: (mouse) => {
                                if (pressed) {
                                    // Si es volumen, actualiza mientras mueves. Si es canción, solo visual (opcional)
                                    if (volumeControl) {
                                        handleInput(mouse.x, false);
                                    }
                                }
                            }

                            onReleased: (mouse) => {
                                if (!volumeControl && isDraggingPos) {
                                    handleInput(mouse.x, true); // Al soltar, enviamos la posición final a Spotify
                                    isDraggingPos = false;
                                }
                            }
                        }
                    }


                    // Song Time
                    Rectangle {
                        Layout.fillWidth: true
                        height: 16
                        color: "transparent"
                        clip: true

                        // Song Time
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            id: songTime
                            text: Mpris.formatTime(Mpris.position)
                            color: ThemeManager.colors.text
                            font.pixelSize: 12
                            font.bold: true
                            font.family: ThemeManager.fonts.main
                        }

                        // Song Duration
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            id: songLeftTime
                            text: Mpris.formatTime(Mpris.duration)
                            color: ThemeManager.colors.text
                            font.pixelSize: 12
                            font.bold: true
                            font.family: ThemeManager.fonts.main
                        }
                    }
                }

                
                // Fix Spacing
                Rectangle {
                    Layout.fillHeight: true
                }


                // Music Control
                GridLayout{
                    Layout.alignment: Qt.AlignHCenter || Qt.AlignBottom
                    Layout.margins: -5
                    columns: 7

                    // Change Player
                    WrapperMouseArea {
                        cursorShape: Mpris.canShuffle ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.shuffle()
                        }
                        
                        Text{
                            text: ""
                            color: ThemeManager.colors.text
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 25
                        }
                    }

                    // Shuffle
                    WrapperMouseArea {
                        cursorShape: Mpris.canShuffle ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.shuffle()
                        }
                        
                        Text{
                            text: Mpris.isShuffled ? "󰒝" : "󰒞"
                            color: Mpris.canShuffle ? (Mpris.isShuffled ? ThemeManager.colors.mauve : ThemeManager.colors.text) : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 30

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                    
                    // Previous
                    WrapperMouseArea {
                        cursorShape: Mpris.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.previous()
                        }
                        
                        Text{
                            text: "󰙣"
                            color: Mpris.canGoPrevious ? ThemeManager.colors.text : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 35

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Play Pause
                    WrapperMouseArea {
                        cursorShape: Mpris.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.playpause()
                        }
                        
                        Text{
                            text: Mpris.isPaused ? "" : ""
                            color: Mpris.canTogglePlaying ? (Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.text) : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 40

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Next
                    WrapperMouseArea {
                        cursorShape: Mpris.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.next()
                        }
                        
                        Text{
                            text: "󰙡"
                            color: Mpris.canGoNext ? ThemeManager.colors.text : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 35

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Repeat
                    WrapperMouseArea {
                        cursorShape: Mpris.canRepeat ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.repeat()
                        }
                        
                        Text{
                            text: Mpris.isRepeating === 0 ? "󰑗" : (Mpris.isRepeating === 1 ? "󰑘" : "󰑖")
                            color: Mpris.canRepeat ? (Mpris.isRepeating === 0 ? ThemeManager.colors.text : ThemeManager.colors.pink) : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 30

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Volume
                    WrapperMouseArea {
                        cursorShape: Mpris.canVolume ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: Mpris.canVolume
                        onClicked: {
                            volumeControl = !volumeControl
                        }
                        
                        Text{
                            text: "󰕾"
                            color: Mpris.canVolume ? (volumeControl ? ThemeManager.colors.green : ThemeManager.colors.text) : ThemeManager.colors.overlay0
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: 25

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }
            }
        }
    }
}