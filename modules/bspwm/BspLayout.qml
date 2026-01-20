// modules/workspaces/BspwmLayout.qml
import QtQuick
import qs.themes
import qs.modules.bspwm

Text {
    id: layoutIndicator

    property string currentLayout: "tiled"

    text: getIcon()
    color: getColor()
    font.family: ThemeManager.fonts.icons
    font.pixelSize: 24

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
            case "tiled": return "󰕮"
            case "monocle": return "󱂬"
            default: return "󰕮"
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