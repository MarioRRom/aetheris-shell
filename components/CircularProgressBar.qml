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

// A rounded progress bar.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes

// Config
import qs.themes

Shape {
    id: root

    // Variables
    property real value: 0.0 // Progress value, from 0.0 to 1.0
    property color foregroundColor: ThemeManager.colors.blue
    property color backgroundColor: ThemeManager.colors.surface0
    property int strokeWidth: 8
    property int startAngle: -90 // -90 degrees is the top of the circle

    // Internal Properties
    readonly property real size: Math.min(width, height)
    readonly property real radius: (size - strokeWidth) / 2
    // Ensures the value is at least slightly visible to avoid glitches
    readonly property real vValue: value > 0.001 ? value : 0.001

    // Use curve renderer for smooth rounded borders
    preferredRendererType: Shape.CurveRenderer
    asynchronous: true

    // Background Ring
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

    // Progress Ring
    ShapePath {
        fillColor: "transparent"
        strokeColor: root.foregroundColor
        strokeWidth: root.strokeWidth
        capStyle: ShapePath.RoundCap // Rounded caps

        PathAngleArc {
            startAngle: root.startAngle
            sweepAngle: 360 * root.vValue
            radiusX: root.radius
            radiusY: root.radius
            centerX: root.size / 2
            centerY: root.size / 2

            // Update Animation
            Behavior on sweepAngle { NumberAnimation { duration: 350 } }
        }

        Behavior on strokeColor { ColorAnimation { duration: 250 } }
    }
}
