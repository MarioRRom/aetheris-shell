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
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

// Config
import qs.config
import qs.components
import qs.themes
import qs.modules


Rectangle {
    property int globalRadius: Config.global.corners
    property int globalMargin: Config.global.margins + 10
    property int itemRadius: globalRadius - globalMargin

    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: globalMargin
    anchors.bottomMargin: globalMargin

    visible: Mpris.status

    color: "transparent"

    

    width: 390
    height: 85
    RowLayout {
        anchors.fill: parent
        spacing: 5

        // Album Cover //
        Rectangle {
            id: albumCover
            width: 85
            height: 85
            color: "transparent"

            // Sombreado
            RectangularShadow {
                visible: Config.shadows.enabled
                anchors.fill: parent
                radius: itemRadius
                color: Config.shadows.color

                blur: 3
                offset: Qt.vector2d(1, 1)
                spread: 0.0
                cached: true
            }

            Image {
                id: albumport
                anchors.fill: parent
                visible: true
                cache: true
                smooth: true
                fillMode: Image.PreserveAspectCrop
                anchors.margins: 2

                source: Mpris.artUrl

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: bgMask
                }

                Rectangle {
                    id: bgMask
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: itemRadius
                    visible: false
                }
            }
        }
        
        // Album Info //
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: "transparent"

            Rectangle {
                anchors.fill: parent

                radius: itemRadius
                anchors.margins: 2
                property color baseColor: ThemeManager.colors.mantle
                color: Qt.rgba(baseColor.r, baseColor.g, baseColor.b, 0.8)
            }

            // Sombreado
            Rectangle {
                visible: Config.shadows.enabled
                anchors.fill: parent
                anchors.margins: 0
                radius: itemRadius
                border.color: Config.shadows.color
                border.width: 5
                color: "transparent"
//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'
                // Blurry Effect
                layer.enabled: true
                layer.effect: MultiEffect {
                    blurEnabled: true
                    blur: 1
                }
            }

            ColumnLayout {
                //anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                spacing: 2

                // Title Marquee
                Rectangle {
                    Layout.fillWidth: true
                    height: 20
                    color: "transparent"
                    clip: true

                    Text {
                        id: titleText
                        anchors.verticalCenter: parent.verticalCenter
                        text: Mpris.title
                        font.pixelSize: 15
                        font.family: ThemeManager.fonts.main
                        font.bold: true
                        color: ThemeManager.colors.text
                    }

                    SequentialAnimation {
                        id: titleAnim
                        loops: Animation.Infinite
                        running: titleText.paintedWidth > parent.width

                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            target: titleText
                            property: "x"
                            from: 0
                            to: titleText.parent.width - titleText.paintedWidth
                            duration: 5000
                        }
                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            target: titleText
                            property: "x"
                            from: titleText.parent.width - titleText.paintedWidth
                            to: 0
                            duration: 5000
                        }
                    }

                    Connections {
                        target: titleText
                        function onTextChanged() {
                            titleAnim.stop()
                            titleText.x = 0
                            if (titleText.paintedWidth > titleText.parent.width) titleAnim.start()
                        }
                    }
                }

                // Artist Marquee
                Rectangle {
                    Layout.fillWidth: true
                    height: 16
                    color: "transparent"
                    clip: true

                    Text {
                        id: artistText
                        anchors.verticalCenter: parent.verticalCenter
                        text: Mpris.artist
                        font.pixelSize: 12
                        font.family: ThemeManager.fonts.main
                        color: ThemeManager.colors.text
                    }

                    SequentialAnimation {
                        id: artistAnim
                        loops: Animation.Infinite
                        running: artistText.paintedWidth > parent.width

                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            target: artistText
                            property: "x"
                            from: 0
                            to: artistText.parent.width - artistText.paintedWidth
                            duration: 5000
                        }
                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            target: artistText
                            property: "x"
                            from: artistText.parent.width - artistText.paintedWidth
                            to: 0
                            duration: 5000
                        }
                    }

                    Connections {
                        target: artistText
                        function onTextChanged() {
                            artistAnim.stop()
                            artistText.x = 0
                            if (artistText.paintedWidth > artistText.parent.width) artistAnim.start()
                        }
                    }
                }

                // Fix Spacing
                Rectangle {
                    Layout.fillHeight: true
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

                    // Song Left Time
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        id: songLeftTime
                        text: "-" + Mpris.formatTime(Mpris.duration - Mpris.position)
                        color: ThemeManager.colors.text
                        font.pixelSize: 12
                        font.bold: true
                        font.family: ThemeManager.fonts.main
                    }
                }

                // Song progress Bar
                HorizontalSlider {
                    sliderHeight: 5
                    backgroundColor: ThemeManager.colors.surface2

                    accent: ThemeManager.colors.subtext1
                    gradient: ThemeManager.colors.text
                    animationDuration: 650
                    value: Mpris.position / Mpris.duration
                    mouseEnabled: false
                    borderEnabled: false
                }
            }
        }
    }
    
}