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
                    HorizontalSlider {
                        sliderHeight: 10
                        backgroundColor: ThemeManager.colors.surface2

                        accent: !volumeControl ? (Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.sapphire) : ThemeManager.colors.green
                        gradient: !volumeControl ? (Mpris.isPaused ? ThemeManager.colors.peach : ThemeManager.colors.sky) : ThemeManager.colors.teal
                        animationDuration: 650
                        value: !volumeControl ? (Mpris.duration > 0 ? Mpris.position / Mpris.duration : 0) : Mpris.volume
                        updateCommand: volumeControl ? Mpris.setVolume : Mpris.setPosition
                        updateOnDrag: volumeControl
                        mouseEnabled: volumeControl ? Mpris.canVolume : (Mpris.canSeek && Mpris.positionSupported)
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