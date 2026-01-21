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


// Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes

Rectangle {
    Layout.fillWidth: true
    height: 139
    color: ThemeManager.colors.base
    radius: 14

    // Definimos la ruta de los backgrounds
    readonly property string assetsPath: "../../assets/weather/"

    // Decoraciones
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
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

    InnerLine {
        anchors.fill: parent
        lineradius: itemRadius
        linewidth: 1
        linecolor: ThemeManager.colors.surface0
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        
        // Sombra para mejorar la legibilidad del texto sobre el fondo
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6
            samples: 12
            color: "#80000000"
        }
        
        // Bloque Izquierdo
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            spacing: 2
            
            RowLayout {
                spacing: 5
                Text { text: ""; color: ThemeManager.colors.text; font.pixelSize: 18; font.family: ThemeManager.fonts.icons }
                Text { text: Weather.location; color: ThemeManager.colors.text; font.pixelSize: 18; font.family: ThemeManager.fonts.main }
            }
            
            Text { text: Weather.temperature; color: ThemeManager.colors.text; font.pixelSize: 35; font.family: ThemeManager.fonts.main; font.bold: true }
            
            Item { Layout.fillHeight: true }
            
            RowLayout {
                spacing: 5
                Text { text: ""; color: ThemeManager.colors.text; font.family: ThemeManager.fonts.icons }
                Text { text: Weather.windSpeed; color: ThemeManager.colors.text; font.family: ThemeManager.fonts.main }
            }

            RowLayout {
                spacing: 5
                Text { text: "󰖌"; color: ThemeManager.colors.text; font.family: ThemeManager.fonts.icons }
                Text { text: Weather.humidity; color: ThemeManager.colors.text; font.family: ThemeManager.fonts.main }
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Bloque Derecho
        ColumnLayout {
            Layout.alignment: Qt.AlignBottom | Qt.AlignRight

            Text { text: Weather.description ; color: ThemeManager.colors.text; font.pixelSize: 18; font.family: ThemeManager.fonts.main; font.bold: true }
        }
    }
}