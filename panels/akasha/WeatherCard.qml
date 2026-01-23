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
import Quickshell.Widgets

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes

Rectangle {
    Layout.fillWidth: true
    height: 139
    color: "transparent"

    // Definimos la ruta de los backgrounds
    readonly property string assetsPath: "../../assets/weather/"

    // Decoraciones
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 3)
        spread: 0.0
        cached: true
    }
    
    
    // Imagen de Fondo con Máscara de Opacidad
    Image {
        anchors.fill: parent
        source: assetsPath + Weather.backgroundImage
        fillMode: Image.PreserveAspectCrop
        
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: bgMask
        }

        Rectangle {
            id: bgMask
            anchors.fill: parent
            radius: itemRadius
            visible: false
        }
    }

    // Contenido
    Item {
        id: container
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 5
        anchors.bottomMargin: 10

        ColumnLayout {
            anchors.fill: parent
            spacing: 2
            
            RowLayout {
                spacing: 5

                Text {
                    text: ""
                    color: "white"
                    font.pixelSize: 18
                    font.family: ThemeManager.fonts.icons
                
                }
                Text {
                    text: Weather.location
                    color: "white"
                    font.pixelSize: 18
                    font.family: ThemeManager.fonts.main
                    font.bold: true
                
                }
                Item { Layout.fillWidth: true }

                Text {
                    Layout.topMargin: -14
                    Layout.bottomMargin: -20
                    text: Weather.temperature
                    color: "white"
                    font.pixelSize: 35
                    font.family: ThemeManager.fonts.main
                    font.bold: true
                }
            }
            
            Item { Layout.fillHeight: true }
            
            Item {
                Layout.fillWidth: true
                height: 40

                Rectangle {
                    anchors.fill: parent
                    color: "#1e1e2e"
                    radius: 8
                    opacity: 0.5
                }
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    ColumnLayout {
                        spacing: -2
                        RowLayout {
                            spacing:5
                            Layout.alignment: Qt.AlignRight
                        
                            Text { text: Weather.windSpeed; color: "white"; font.family: ThemeManager.fonts.main }
                            Text { text: ""; color: "white"; font.family: ThemeManager.fonts.icons }
                        }
                        RowLayout {
                            Layout.alignment: Qt.AlignRight
                            spacing: 5
                            Text { text: Weather.humidity; color: "white"; font.family: ThemeManager.fonts.main }
                            Text { text: "󰖌"; color: "white"; font.family: ThemeManager.fonts.icons }
                        }
                    }
                    Text { text: "|" ; color: "white"; font.pixelSize: 25; font.family: ThemeManager.fonts.main; font.bold: true }
                    Text { text: Weather.description ; color: "white"; font.pixelSize: 18; font.family: ThemeManager.fonts.main; font.bold: true }
                }
            }
        }
    }
}