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
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

// Config
import qs.components
import qs.config
import qs.services
import qs.themes

Rectangle {
    id: weatherCard
    Layout.fillWidth: true

    height: 139
    color: "transparent"

    required property int itemRadius

    // Background assets path
    readonly property string assetsPath: "../../assets/weather/"

    // Internal card margins
    property int infoMargins: 10

    // Shadow
    RectangularShadow {
        anchors.fill: parent
        radius: weatherCard.itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 3)
        spread: 0.0
        cached: true
    }


    // Background Image with Opacity Mask
    Image {
        anchors.fill: parent
        source: weatherCard.assetsPath + Weather.backgroundImage
        fillMode: Image.PreserveAspectCrop

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: bgMask
        }

        Rectangle {
            id: bgMask
            anchors.fill: parent
            radius: weatherCard.itemRadius
            visible: false
        }
    }

    // Content
    Item {
        id: container
        anchors.fill: parent
        anchors.leftMargin: weatherCard.infoMargins
        anchors.rightMargin: weatherCard.infoMargins
        anchors.topMargin: (weatherCard.infoMargins / 2)
        anchors.bottomMargin: weatherCard.infoMargins

        ColumnLayout {
            anchors.fill: parent
            spacing: 2

            RowLayout {
                spacing: 5

                SvgIcon {
                    icon: "maps/location"
                    size: 18
                    color: "white"
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
                    radius: weatherCard.itemRadius - weatherCard.infoMargins
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

                            Text {
                                text: Weather.windSpeed
                                color: "white"
                                font.pixelSize: 12
                                font.family: ThemeManager.fonts.main
                            }

                            SvgIcon {
                                icon: "weather/wind"
                                size: 12
                                color: "white"
                            }
                        }
                        RowLayout {
                            Layout.alignment: Qt.AlignRight
                            spacing: 5
                            Text {
                                text: Weather.humidity
                                color: "white"
                                font.pixelSize: 12
                                font.family: ThemeManager.fonts.main
                            }

                            SvgIcon {
                                icon: "weather/humidity-percentage"
                                size: 12
                                color: "white"
                            }
                        }
                    }
                    Text {
                        text: "|"
                        color: "white"
                        font.pixelSize: 25
                        font.family: ThemeManager.fonts.main
                        font.bold: true
                    }

                    Text {
                        text: Weather.description
                        color: "white"
                        font.pixelSize: 18
                        font.family: ThemeManager.fonts.main
                        font.bold: true
                    }
                }
            }
        }
    }
}