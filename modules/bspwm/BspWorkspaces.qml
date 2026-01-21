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

// Workspaces indicator para bspwm usando socket directo
// Refactorizado para usar BspSocket singleton en lugar de scripts externos
// Gracias a Catdeal3r por ayudarme. https://github.com/catdeal3r


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Módulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import Quickshell

// Globales
import qs.themes
import qs.modules.bspwm


Row {
    id: iconRow
    spacing: 7
    
    // Propiedad pública: nombre del monitor
    property string monitorName: ""
    
    // Datos internos
    property var workspaceNames: []     // Nombres de los workspaces (1, 2, 3...)
    property var workspaceIds: []       // IDs hexadecimales
    property var occupiedWorkspaces: [] // Workspaces con ventanas
    property string focusedWorkspace: "" // Workspace actualmente enfocado
    
    // Alias para compatibilidad
    readonly property string bspwmName: monitorName

    
    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Layout Visual     | |
    //  | `---------------------' |
    //  `-------------------------'
        
    Repeater {
        model: workspaceNames

        Text {
            property string wsName: modelData
            text: wsName === focusedWorkspace ? "󰮯" : occupiedWorkspaces.indexOf(wsName) !== -1 ? "󰊠" : "󰧞"
            color: wsName === focusedWorkspace ? ThemeManager.colors.yellow : occupiedWorkspaces.indexOf(wsName) !== -1 ? ThemeManager.colors.sky : ThemeManager.colors.overlay1
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 16
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
    //  | | Conexión de Socket  | |
    //  | `---------------------' |
    //  `-------------------------'
    
    Connections {
        target: BspSocket
        
        // Cuando se actualizan los workspaces
        function onWorkspacesUpdated(monitor) {
            if (monitor !== monitorName) return
            
            var data = BspSocket.workspaceData[monitor]
            if (!data) return
            
            // Actualizar datos disponibles
            if (data.names) workspaceNames = data.names
            if (data.ids) workspaceIds = data.ids
            if (data.occupied) occupiedWorkspaces = data.occupied
            if (data.focused) focusedWorkspace = data.focused
            
            // Continuar con la siguiente query SOLO después de actualizar
            executeNextQuery()
        }
        
        // Cuando cambia el desktop enfocado
        function onDesktopFocused(monitorId, desktopId, desktopName) {
            // Si el desktop pertenece a este monitor, actualizar el foco
            var idx = workspaceIds.indexOf(desktopId)
            if (idx !== -1) {
                focusedWorkspace = workspaceNames[idx]
            }
        }
        
        // Cuando cambian los nodos
        function onNodeChanged() {
            queryStep = 2  // Solo actualizar ocupados
            executeNextQuery()
        }
    }
    
    //  .-------------------------.
    //  | .---------------------. |
    //  | |     Funciones       | |
    //  | `---------------------' |
    //  `-------------------------'
    
    // Cambiar a un workspace
    function switchTo(index) {
        if (index >= 0 && index < workspaceIds.length) {
            BspSocket.switchDesktop(workspaceIds[index])
        }
    }
    

    
    // Estado de la query en progreso
    property int queryStep: 0
    
    // Query completo de datos del workspace (SECUENCIAL)
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
    //  | |   Inicialización    | |
    //  | `---------------------' |
    //  `-------------------------'
    
    Component.onCompleted: {
        console.log("Bspwm workspaces inicializado para monitor:", monitorName)
        queryWorkspaceData()

    }
    
    // Refrescar cuando cambia el monitor
    onMonitorNameChanged: {
        if (monitorName !== "") {
            Qt.callLater(() => {
                queryWorkspaceData()
            })
        }
    }
}