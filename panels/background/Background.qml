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
import QtQuick.Effects
import Quickshell

// Global
import qs.config
import qs.themes

Variants {
    id: root
    model: Quickshell.screens
    property bool isActivated: false
    property QtObject backgroundAnchor: null

    LazyLoader {
        active: isActivated
        required property var modelData

        component: PanelWindow {
            visible: true
            id: bgRoot
            screen: modelData
            Component.onCompleted: if (!root.backgroundAnchor) root.backgroundAnchor = bgRoot

            // Abajo de todo
            aboveWindows: false
            exclusionMode: ExclusionMode.Ignore
            
            // Fullscreen en cada monitor
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            
            color: ThemeManager.colors.mantle

            mask: Region {}
            
            
            //  .-------------------------.
            //  | .---------------------. |
            //  | |     Background      | |
            //  | `---------------------' |
            //  `-------------------------'

            Item {
                id: backgroundContainer
                anchors.fill: parent
                
                //fix cuando la barra esta maximizada.
                anchors.topMargin: Config.topBar.state === "maximized" ? Config.topBar.height : 0

                // Bordeado cuando la barra esta maximizada.
                anchors.leftMargin: Config.topBar.state === "maximized" ? Config.global.wallborder : 0
                anchors.rightMargin: Config.topBar.state === "maximized" ? Config.global.wallborder : 0
                anchors.bottomMargin: Config.topBar.state === "maximized" ? Config.global.wallborder : 0
                
                // Hug Corners
                layer.enabled: Config.topBar.state === "maximized" && Config.topBar.hug
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            width: backgroundContainer.width 
                            height: backgroundContainer.height
                            y: 40
                            radius: Config.global.corners
                        }
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |      Wallpaper      | |
                //  | `---------------------' |
                //  `-------------------------'
                
                Wallpaper {
                    id: wallpaper
                    anchors.fill: parent
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |     Now Playing     | |
                //  | `---------------------' |
                //  `-------------------------'
                NowPlaying {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |  Background Shadow  | |
                //  | `---------------------' |
                //  `-------------------------'

                Loader {
                    id: backgroundShadow
                    anchors.fill: parent 
                    // Solo cuando la barra esta Maximizada
                    active: Config.shadows.enabled && Config.topBar.state === "maximized"

                    sourceComponent: Rectangle {
                        anchors.fill: parent
                        anchors.margins: -10
                        color: "transparent"

                        // Shadow Config 
                        border.color: Config.shadows.color
                        border.width: 15
                        radius: Config.topBar.hug ? (Config.global.corners + 12) : 0

                        // Blurry Effect
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            blurEnabled: true
                            blur: 1
                        }
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |      Bar Shadow     | |
                //  | `---------------------' |
                //  `-------------------------'
                
                // Sombra de la barra en float.
                Loader {
                    id: barShadows
                    anchors.fill: parent
                    active: Config.shadows.enabled && Config.topBar.state === "float"

                    sourceComponent: Item {
                        RectangularShadow {
                            id: topShadow
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right

                                topMargin: Config.global.margins
                                leftMargin: Math.round(modelData.width * 0.02)
                                rightMargin: Math.round(modelData.width * 0.02)
                            }
                            
                            height: Config.topBar.height
                            radius: Config.global.corners
                            color: Config.shadows.color

                            blur: 5
                            offset: Qt.vector2d(0, 2)
                            spread: 0.5
                            cached: true
                        }
                    }
                }
            }
        }
    }
}