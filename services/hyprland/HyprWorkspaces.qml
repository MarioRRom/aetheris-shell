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
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Config
import qs.themes


Row {
    id: iconRow
    spacing: 7

    // Public property: monitor name
    property string monitorName: ""

    // Internal data
    property var workspaceNames: []
    property var occupiedWorkspaces: []
    property string focusedWorkspace: ""


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Visual Layout    | |
    //  | `---------------------' |
    //  `-------------------------'

    Repeater {
        model: workspaceNames

        Text {
            property string wsName: modelData

            text: wsName === focusedWorkspace ? "󰮯"
                : occupiedWorkspaces.indexOf(wsName) !== -1 ? "󰊠"
                : "󰊠"

            color: wsName === focusedWorkspace ? ThemeManager.colors.yellow
                : occupiedWorkspaces.indexOf(wsName) !== -1 ? ThemeManager.colors.sky
                : ThemeManager.colors.sky

            font.family: ThemeManager.fonts.icons
            font.pixelSize: 16

            Behavior on color { ColorAnimation { duration: 350 } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (!Hyprland.workspaces) return

                    const wsObj = Hyprland.workspaces.values.find(w =>
                        w &&
                        w.name === wsName &&
                        w.monitor &&
                        w.monitor.name === monitorName
                    )

                    if (wsObj)
                        Hyprland.dispatch(`workspace ${wsObj.id}`)
                }
            }
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Hyprland Connection | |
    //  | `---------------------' |
    //  `-------------------------'

    Connections {
        target: Hyprland
        
        // When workspaces are updated
        function onRawEvent(event) {
            if (!Hyprland.workspaces) return

            let wsList = []
            let occList = []
            let focused = null

            for (let ws of Hyprland.workspaces.values) {
                if (!ws || !ws.monitor || !ws.monitor.name) continue
                if (ws.monitor.name !== monitorName) continue

                wsList.push(ws.name)

                if (ws.occupied)
                    occList.push(ws.name)

                if (ws.focused)
                    focused = ws.name
            }

            workspaceNames = wsList
            occupiedWorkspaces = occList
            focusedWorkspace = focused ?? ""
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Initialization    | |
    //  | `---------------------' |
    //  `-------------------------'

    Component.onCompleted: {
        if (!Hyprland.workspaces) return

        let wsList = []
        let occList = []
        let focused = null

        for (let ws of Hyprland.workspaces.values) {
            if (!ws || !ws.monitor || !ws.monitor.name) continue
            if (ws.monitor.name !== monitorName) continue

            wsList.push(ws.name)

            if (ws.occupied)
                occList.push(ws.name)

            if (ws.focused)
                focused = ws.name
        }

        workspaceNames = wsList
        occupiedWorkspaces = occList
        focusedWorkspace = focused ?? ""
    }
}
