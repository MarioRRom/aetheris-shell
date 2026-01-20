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
import QtQuick
import QtQuick.Shapes

// Globales
import qs.themes

Shape {
    id: root

    // Variables
    property real value: 0.0 // El valor del progreso, de 0.0 a 1.0
    property color foregroundColor: ThemeManager.colors.blue
    property color backgroundColor: ThemeManager.colors.surface0
    property int strokeWidth: 8
    property int startAngle: -90 // -90 grados es la parte superior del círculo

    // Propiedades Internas
    readonly property real size: Math.min(width, height)
    readonly property real radius: (size - strokeWidth) / 2
    // Asegura que el valor sea al menos un poco visible para evitar glitches
    readonly property real vValue: value > 0.001 ? value : 0.001

    // Usar el renderizador de curvas para bordes redondeados suaves
    preferredRendererType: Shape.CurveRenderer
    asynchronous: true

    // Anillo de Fondo
    ShapePath {
        fillColor: "transparent"
        strokeColor: root.backgroundColor
        strokeWidth: root.strokeWidth

        PathAngleArc {
            radiusX: root.radius
            radiusY: root.radius
            centerX: root.size / 2
            centerY: root.size / 2
            startAngle: 0
            sweepAngle: 360
        }
    }

    // Anillo de Progreso
    ShapePath {
        fillColor: "transparent"
        strokeColor: root.foregroundColor
        strokeWidth: root.strokeWidth
        capStyle: ShapePath.RoundCap // Extremos redondeados

        PathAngleArc {
            startAngle: root.startAngle
            sweepAngle: 360 * root.vValue
            radiusX: root.radius
            radiusY: root.radius
            centerX: root.size / 2
            centerY: root.size / 2

            // Animación de Actualizaciones
            Behavior on sweepAngle { NumberAnimation { duration: 350 } }
        }

        Behavior on strokeColor { ColorAnimation { duration: 250 } }
    }
}
