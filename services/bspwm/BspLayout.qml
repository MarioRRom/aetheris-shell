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

// Config
import qs.components
import qs.themes
import qs.services.bspwm

SvgIcon {
    id: layoutIndicator

    property string currentLayout: "tiled"

    icon: getIcon()
    color: getColor()
    size: 24

    Connections {
        target: BspSocket

        function onLayoutChanged(layout, desktop) {
            currentLayout = layout
        }

        function onDesktopLayoutChanged(monitorId, desktopId, layout) {
            currentLayout = layout
        }

        function onDesktopFocused(monitorId, desktopId, desktopName) {
            BspSocket.queryLayout(desktopId)
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            BspSocket.toggleLayout()
        }
    }

    function getIcon() {
        switch(currentLayout) {
            case "tiled": return "general/dashboard"
            case "monocle": return "general/single-window"
            default: return "general/dashboard"
        }
    }

    function getColor() {
        switch(currentLayout) {
            case "tiled": return ThemeManager.colors.sky
            case "monocle": return ThemeManager.colors.yellow
            default: return ThemeManager.colors.text
        }
    }

    Component.onCompleted: {
        BspSocket.queryLayout()
    }
}