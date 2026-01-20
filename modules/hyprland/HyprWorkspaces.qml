import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.themes

Rectangle {
    id: workspaceContainer
    height: 24
    color: ThemeManager.colors.surface0
    radius: 10

    property string monitorName: ""
    property var workspaceNames: []
    property string focusedWorkspace: ""
    property var occupiedWorkspaces: []

    Row {
        id: iconRow
        anchors.centerIn: parent
        spacing: 7
        leftPadding: 10
        rightPadding: 10

        Repeater {
            model: workspaceNames
            Text {
                property string wsName: modelData
                text: wsName === focusedWorkspace ? "󰮯"
                      : occupiedWorkspaces.indexOf(wsName) !== -1 ? "󰊠"
                      : "󰧞"
                color: wsName === focusedWorkspace ? ThemeManager.colors.yellow
                        : occupiedWorkspaces.indexOf(wsName) !== -1 ? ThemeManager.colors.sky
                        : ThemeManager.colors.overlay1
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const wsObj = Hyprland.workspaces.values.find(w => w.name === wsName && w.monitor.name === monitorName)
                        if (wsObj) Hyprland.dispatch(`workspace ${wsObj.id}`)
                    }
                }
            }
        }
    }
    width: iconRow.width

    // =====================================
    // Conexión a Hyprland
    // =====================================
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (!Hyprland.workspaces) return

            let wsList = []
            let occList = []
            let focused = null

            for (let ws of Hyprland.workspaces.values) {
                if (ws.monitor.name !== monitorName) continue
                wsList.push(ws.name)
                if (ws.occupied) occList.push(ws.name)
                if (ws.focused) focused = ws.name
            }

            workspaceNames = wsList
            occupiedWorkspaces = occList
            focusedWorkspace = focused
        }
    }

    Component.onCompleted: {
        // Inicializar con los workspaces actuales
        if (!Hyprland.workspaces) return

        let wsList = []
        let occList = []
        let focused = null

        for (let ws of Hyprland.workspaces.values) {
            if (ws.monitor.name !== monitorName) continue
            wsList.push(ws.name)
            if (ws.occupied) occList.push(ws.name)
            if (ws.focused) focused = ws.name
        }

        workspaceNames = wsList
        occupiedWorkspaces = occList
        focusedWorkspace = focused
    }
}
