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

// Workspaces indicator for bspwm using direct socket
// Refactored to use BspSocket singleton instead of external scripts
// Thanks to Catdeal3r for helping. https://github.com/catdeal3r


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


Row {
    id: iconRow
    spacing: 4

    // Public property: monitor name
    property string monitorName: ""

    // Internal data
    property var workspaceNames: []     // Workspace names (1, 2, 3...)
    property var workspaceIds: []       // Hex IDs
    property var occupiedWorkspaces: [] // Workspaces with windows
    property string focusedWorkspace: "" // Currently focused workspace

    // Alias for compatibility
    readonly property string bspwmName: monitorName


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Visual Layout    | |
    //  | `---------------------' |
    //  `-------------------------'

    Repeater {
        model: workspaceNames

        SvgIcon {
            required property var modelData
            required property int index

            property string wsName: modelData
            icon: wsName === focusedWorkspace ? "workspaces/pacman" : occupiedWorkspaces.indexOf(wsName) !== -1 ? "workspaces/ghost" : "workspaces/dot"
            color: wsName === focusedWorkspace ? ThemeManager.colors.yellow : occupiedWorkspaces.indexOf(wsName) !== -1 ? ThemeManager.colors.sky : ThemeManager.colors.overlay1
            size: 16
            Behavior on color { ColorAnimation { duration: 350 } }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: switchTo(index)
            }
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Socket Connection  | |
    //  | `---------------------' |
    //  `-------------------------'

    Connections {
        target: BspSocket

        // When workspaces are updated
        function onWorkspacesUpdated(monitor) {
            if (monitor !== monitorName) return

            var data = BspSocket.workspaceData[monitor]
            if (!data) return

            // Update available data
            if (data.names) workspaceNames = data.names
            if (data.ids) workspaceIds = data.ids
            if (data.occupied) occupiedWorkspaces = data.occupied
            if (data.focused) focusedWorkspace = data.focused

            // Continue with the next query ONLY after updating
            executeNextQuery()
        }

        // When focused desktop changes
        function onDesktopFocused(monitorId, desktopId, desktopName) {
            // If the desktop belongs to this monitor, update focus
            var idx = workspaceIds.indexOf(desktopId)
            if (idx !== -1) {
                focusedWorkspace = workspaceNames[idx]
            }
        }

        // When nodes change
        function onNodeChanged() {
            queryStep = 2  // Only update occupied
            executeNextQuery()
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |      Functions      | |
    //  | `---------------------' |
    //  `-------------------------'

    // Switch to a workspace
    function switchTo(index) {
        if (index >= 0 && index < workspaceIds.length) {
            BspSocket.switchDesktop(workspaceIds[index])
        }
    }



    // Query in progress state
    property int queryStep: 0

    // Full workspace data query (SEQUENTIAL)
    function queryWorkspaceData() {
        if (monitorName === "") return
        queryStep = 0
        executeNextQuery()
    }

    function executeNextQuery() {
        if (monitorName === "") return


        switch(queryStep) {
            case 0:
                if (typeof BspSocket.queryWorkspaces === "function") {
                    BspSocket.queryWorkspaces(monitorName)
                }
                break
            case 1:
                BspSocket.queryWorkspaceIds(monitorName)
                break
            case 2:
                BspSocket.queryOccupiedWorkspaces(monitorName)
                break
            case 3:
                BspSocket.queryFocusedWorkspace(monitorName)
                break
            default:
                return
        }
        queryStep++
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Initialization    | |
    //  | `---------------------' |
    //  `-------------------------'

    Component.onCompleted: {
        console.log("Bspwm workspaces initialized for monitor:", monitorName)
        queryWorkspaceData()

    }

    // Refresh when monitor changes
    onMonitorNameChanged: {
        if (monitorName !== "") {
            Qt.callLater(() => {
                queryWorkspaceData()
            })
        }
    }
}