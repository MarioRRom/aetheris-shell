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

// HorizontalSlider: Customizable horizontal slider component
// with gradient progress bar and mouse interaction.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// Config
import qs.themes


Rectangle {
    id: slider

    // Slider Aspect
    property real sliderHeight: 19
    property color accent: ThemeManager.colors.green
    property color gradientColor: ThemeManager.colors.teal

    property color backgroundColor: ThemeManager.colors.overlay0
    property color borderColor: ThemeManager.colors.surface0
    property bool borderEnabled: true

    property int animationDuration: 350

    property int cursor: Qt.PointingHandCursor
    property int cursorShape: mouseEnabled ? cursor : Qt.ArrowCursor

    // Slider Functions
     property real value: 50
    property var updateCommand: null

    // Slider Behavior
    property bool updateOnDrag: true
    property bool updateOnRelease: false
    property bool updateOnPress: true
    property bool usePercentage: false
    property bool mouseEnabled: true


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Slider Background  | |
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
    //  | |     Slider Bar      | |
    //  | `---------------------' |
    //  `-------------------------'

    Rectangle {
        height: parent.height
        width: Math.max(parent.height, parent.width * Math.min(1, slider.value / (slider.usePercentage ? 100 : 1)))
        radius: 20
        color: "transparent"
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: slider.accent
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            GradientStop {
                position: 1.0
                color: slider.gradientColor
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: slider.animationDuration
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
        enabled: slider.mouseEnabled
        cursorShape: slider.cursorShape

        function updateValue(mouseX) {
            var maxVal = slider.usePercentage ? 100 : 1;
            var newValue = Math.max(0, Math.min(maxVal, (mouseX / width) * maxVal));
            if (slider.updateCommand) slider.updateCommand(slider.usePercentage ? Math.round(newValue) : newValue);
        }

        onPressed: (mouse) => {
            if (slider.updateOnPress) updateValue(mouse.x);
        }
        onPositionChanged: (mouse) => {
            if (pressed && slider.updateOnDrag) updateValue(mouse.x);
        }
        onReleased: (mouse) => {
            if (slider.updateOnRelease) updateValue(mouse.x);
        }
    }
}