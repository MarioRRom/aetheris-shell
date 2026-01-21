//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝
//                       MarioRRom's Aetheris Shell
//                https://github.com/MarioRRom/aetheris-shell
//===========================================================================

// HorizontalSlider: Componente de slider horizontal personalizable
// con barra de progreso en gradiente y interacción de mouse.


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
import Quickshell
import Quickshell.Widgets

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes


Rectangle {
    id: horizontalSlider

    // Aspecto del Slider
    property real sliderHeight: 19
    property color accent: ThemeManager.colors.green
    property color gradient: ThemeManager.colors.teal

    property color backgroundColor: ThemeManager.colors.overlay0
    property color borderColor: ThemeManager.colors.surface0
    property bool borderEnabled: true

    property int animationDuration: 350

    property int cursor: Qt.PointingHandCursor
    property int cursorShape: mouseEnabled ? cursor : Qt.ArrowCursor

    // Funciones de Slider
     property real value: 50
    property var updateCommand: null

    // Comportamiento del Slider
    property bool updateOnDrag: true
    property bool updateOnRelease: false
    property bool updateOnPress: true
    property bool usePercentage: false
    property bool mouseEnabled: true
    

    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Fondo Slider     | |
    //  | `---------------------' |
    //  `-------------------------'

    Layout.fillWidth: true
    height: sliderHeight
    radius: 20
    color: backgroundColor
    Layout.alignment: Qt.AlignVCenter
    border.width: borderEnabled ? 2 : 0
    border.color: borderColor
    clip: true


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Barra Slider     | |
    //  | `---------------------' |
    //  `-------------------------'

    Rectangle {
        height: parent.height
        width: Math.max(parent.height, parent.width * (horizontalSlider.value / (usePercentage ? 100 : 1)))
        radius: 20
        color: "transparent"
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: accent
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            GradientStop {
                position: 1.0
                color: horizontalSlider.gradient
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: animationDuration
                easing.type: Easing.OutQuint
            }
        }
    }
    

    //  .-------------------------.
    //  | .---------------------. |
    //  | |     Mouse Area      | |
    //  | `---------------------' |
    //  `-------------------------'

    MouseArea {
        anchors.fill: parent
        enabled: horizontalSlider.mouseEnabled
        cursorShape: horizontalSlider.cursorShape

        function updateValue(mouseX) {
            var maxVal = usePercentage ? 100 : 1;
            var newValue = Math.max(0, Math.min(maxVal, (mouseX / width) * maxVal));
            if (horizontalSlider.updateCommand) horizontalSlider.updateCommand(usePercentage ? Math.round(newValue) : newValue);
        }

        onPressed: (mouse) => {
            if (updateOnPress) updateValue(mouse.x);
        }
        onPositionChanged: (mouse) => {
            if (pressed && updateOnDrag) updateValue(mouse.x);
        }
        onReleased: (mouse) => {
            if (updateOnRelease) updateValue(mouse.x);
        }
    }
}