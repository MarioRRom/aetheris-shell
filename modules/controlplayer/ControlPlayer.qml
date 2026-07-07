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
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// Config
import qs.config
import qs.components
import qs.themes
import qs.i18n
import qs.services


PopupWindow {
    id: root

    // Config
    property var bar
    property real globalPos: 0
    property bool volumeControl: false
    property string currentView: "player"


    // Window Radius is set from the global Configuration.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin

    property int windowMargin: 10 // Internal margin.
    property int itemRadius: cornerRadius - windowMargin

    implicitWidth: 290
    implicitHeight: currentView === "player" ? 100 : playerList.contentHeight < 100 ? 100 : (playerList.contentHeight + (windowMargin * 2) + 10)

    anchor.window: bar
    anchor.rect.x: globalPos - (width - 200) // 5px for the margin in the Main Container.
    anchor.rect.y: bar.height + (globalMargin - 5) //5px for the Margin of the Main Container.

    color: "transparent"


    // Main Container
    Rectangle {
        id: conPlayer
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false

        // Shadow
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

        // Window Content
        Rectangle {
            anchors.fill: parent
            radius: cornerRadius
            color: ThemeManager.colors.mantle

            // Decoration
            InnerLine {
                anchors.fill: parent
                lineradius: cornerRadius
                linewidth: 2
                linecolor: ThemeManager.colors.surface0
            }

            // Main column (Player)
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: windowMargin
                spacing: 0
                visible: currentView === "player"


                // Time and Volume Controls
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

                        // Player Name
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            id: playName
                            text: Mpris.player
                            color: ThemeManager.colors.green
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
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.margins: -5
                    columns: 7

                    // Change Player
                    WrapperMouseArea {
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            currentView = "listplayers"
                        }

                        SvgIcon {
                            icon: "general/menu"
                            size: 25
                            color: ThemeManager.colors.text

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Shuffle
                    WrapperMouseArea {
                        cursorShape: Mpris.canShuffle ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.shuffle()
                        }

                        SvgIcon {
                            icon: "media/shuffle"
                            size: 25
                            color: Mpris.canShuffle ? (Mpris.isShuffled ? ThemeManager.colors.mauve : ThemeManager.colors.text) : ThemeManager.colors.overlay0

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Previous
                    WrapperMouseArea {
                        cursorShape: Mpris.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.previous()
                        }

                        SvgIcon {
                            icon: "media/skip-previous"
                            size: 35
                            color: Mpris.canGoPrevious ? ThemeManager.colors.text : ThemeManager.colors.overlay0

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Play Pause
                    WrapperMouseArea {
                        cursorShape: Mpris.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.playpause()
                        }

                        SvgIcon {
                            icon: Mpris.isPaused ? "media/play-circle" : "media/pause-circle"
                            size: 40
                            color: Mpris.canTogglePlaying ? (Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.text) : ThemeManager.colors.overlay0

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Next
                    WrapperMouseArea {
                        cursorShape: Mpris.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.next()
                        }

                        SvgIcon {
                            icon: "media/skip-next"
                            size: 35
                            color: Mpris.canGoNext ? ThemeManager.colors.text : ThemeManager.colors.overlay0

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // Repeat
                    WrapperMouseArea {
                        cursorShape: Mpris.canRepeat ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            Mpris.repeat()
                        }

                        SvgIcon {
                            icon: Mpris.isRepeating === 0 ? "media/repeat" : (Mpris.isRepeating === 1 ? "media/repeat-one" : "media/repeat")
                            size: 25
                            color: Mpris.canRepeat ? (Mpris.isRepeating === 0 ? ThemeManager.colors.text : ThemeManager.colors.pink) : ThemeManager.colors.overlay0

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

                        SvgIcon {
                            icon: "hardware/speaker"
                            size: 25
                            color: Mpris.canVolume ? (volumeControl ? ThemeManager.colors.green : ThemeManager.colors.text) : ThemeManager.colors.overlay0

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }
            }

            // Player List
            ListView {
                id: playerList
                anchors.fill: parent
                anchors.margins: windowMargin
                visible: currentView === "listplayers"
                clip: true
                spacing: 5

                // Assuming Mpris exposes a list of players called 'players'
                model: Mpris.allPlayers

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 30
                    radius: itemRadius
                    color: modelData === Mpris.activePlayer ? ThemeManager.colors.overlay0 : ThemeManager.colors.surface0


                    Text {
                        anchors.centerIn: parent
                        // Shows the player name (e.g. "Spotify")
                        text: modelData.identity || LanguageManager.t("weather.unknown")
                        color: ThemeManager.colors.text
                        font.family: ThemeManager.fonts.main
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Mpris.selectPlayer(modelData)
                            currentView = "player"
                            volumeControl = false
                        }
                    }
                }
            }
        }
    }
}