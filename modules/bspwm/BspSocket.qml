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


// Esta es mi propuesta de Socket para Bspwm. 
// Obtiene los Workspaces y estados por monitor, tambien el layout.


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // Socket de bspwm (para comandos)
    property Socket socket: Socket {
        id: bspwmSocket
        
        path: {
            var display = Quickshell.env("DISPLAY") || ":0"
            var displayNum = display.replace(":", "").split(".")[0]
            return "/tmp/bspwm_" + displayNum + "_0-socket"
        }
        
        connected: false
        
        // Buffer para acumular la respuesta completa
        property string responseBuffer: ""
        
        parser: SplitParser {
            onRead: (message) => {
                // Acumular en buffer (la respuesta puede venir en chunks)
                bspwmSocket.responseBuffer += message
            }
        }

        onConnectedChanged: {
            if (connected) {
                responseBuffer = ""
            } else {
                if (responseBuffer.trim() !== "") {
                    root.handleMessage(responseBuffer)
                }

                // Resetear estado
                processingCommand = false
                currentQueryType = ""
                Qt.callLater(() => {
                    processQueue()
                })
            }
        }

        onError: (error) => {
            // Error 1 = PeerClosedError (normal, bspwm cierra después de responder)
            // Otros errores se ignoran silenciosamente
        }
    }

    // Socket dedicado para eventos (subscribe)
    property Socket eventSocket: Socket {
        id: bspwmEventSocket
        
        path: bspwmSocket.path
        connected: false  // Activar manualmente cuando se necesite
        
        parser: SplitParser {
            onRead: (message) => {
                root.handleEvent(message)
            }
        }

        onConnectedChanged: {
            if (connected) {
                // Suscribirse a eventos
                Qt.callLater(() => {
                    subscribeToEvents()
                })
            }
        }
    }

    // Suscribirse a eventos (mantiene conexión abierta)
    function subscribeToEvents() {
        if (!bspwmEventSocket.connected) return
        
        var cmd = "subscribe desktop_focus desktop_layout node_add node_remove node_transfer"
        var args = cmd.split(" ")
        
        // Protocolo bspwm: arg1\0arg2\0arg3\0
        for (var i = 0; i < args.length; i++) {
            bspwmEventSocket.write(args[i] + "\0")
        }
        bspwmEventSocket.flush()
    }

    // === ESTADO INTERNO ===
    property var workspaceData: ({})
    property var layoutData: ({})
    property var monitorData: ({})
    property var tempMonitorIds: []
    property string currentDesktop: ""
    
    // Cola de comandos con tipo
    property var commandQueue: []
    property bool processingCommand: false
    property string currentQueryType: ""
    
    // === FUNCIONES PÚBLICAS ===

    /**
     * Consulta los nombres de los workspaces de un monitor específico.
     * @param {string} monitor - Nombre del monitor (ej. "HDMI-A-0")
     */
    function queryWorkspaces(monitor) {
        sendCommand("query -D -m " + monitor + " --names", "workspaces:" + monitor)
    }

    /**
     * Consulta los IDs hexadecimales de los workspaces de un monitor.
     * @param {string} monitor - Nombre del monitor
     */
    function queryWorkspaceIds(monitor) {
        sendCommand("query -D -m " + monitor, "workspace_ids:" + monitor)
    }

    /**
     * Consulta los workspaces ocupados (con ventanas) de un monitor.
     * @param {string} monitor - Nombre del monitor
     */
    function queryOccupiedWorkspaces(monitor) {
        sendCommand("query -D -m " + monitor + " -d .occupied --names", "occupied:" + monitor)
    }

    /**
     * Consulta el workspace enfocado de un monitor.
     * @param {string} monitor - Nombre del monitor
     */
    function queryFocusedWorkspace(monitor) {
        sendCommand("query -D -m " + monitor + " -d focused --names", "focused:" + monitor)
    }

    /**
     * Cambia el foco al desktop especificado por ID.
     * @param {string} desktopId - ID hexadecimal del desktop (ej. "0x00200012")
     */
    function switchDesktop(desktopId) {
        sendCommand("desktop " + desktopId + " -f", "")
    }

    /**
     * Alterna el layout del desktop actual (tiled <-> monocle).
     */
    function toggleLayout() {
        sendCommand("desktop -l next", "")
        // Re-query layout after toggle
        Qt.callLater(() => queryLayout(), 100)
    }

    /**
     * Consulta el layout del desktop especificado o del enfocado.
     * @param {string} [desktop] - ID del desktop (opcional, por defecto enfocado)
     */
    function queryLayout(desktop) {
        if (desktop) {
            sendCommand("query -T -d " + desktop, "layout")
        } else {
            sendCommand("query -T -d focused", "layout")
        }
    }

    /**
     * Consulta la lista de monitores disponibles.
     */
    function queryMonitors() {
        sendCommand("query -M", "monitor_ids")
    }

    // === FUNCIONES INTERNAS ===

    /**
     * Envía un comando al socket de bspwm con tipo para tracking.
     * @param {string} cmd - Comando bspwm (ej. "query -D -m HDMI-A-0 --names")
     * @param {string} type - Tipo de query para manejar respuesta (ej. "workspaces:HDMI-A-0")
     */
    function sendCommand(cmd, type) {
        commandQueue.push({cmd: cmd, type: type})
        processQueue()
    }

    /**
     * Procesa la cola de comandos de forma secuencial.
     * Maneja reconexión automática si el socket no está conectado.
     */
    function processQueue() {
        if (processingCommand || commandQueue.length === 0) {
            return
        }

        var item = commandQueue.shift()
        processingCommand = true
        currentQueryType = item.type

        if (!bspwmSocket.connected) {
            bspwmSocket.connected = true

            Qt.callLater(() => {
                if (bspwmSocket.connected) {
                    writeCommand(item.cmd)
                } else {
                    processingCommand = false
                    currentQueryType = ""
                    processQueue()
                }
            })
        } else {
            writeCommand(item.cmd)
        }
    }
    
    /**
     * Escribe el comando al socket usando el protocolo de bspwm.
     * Formato: arg1\0arg2\0arg3\0 (null-terminated strings)
     * @param {string} cmd - Comando a enviar
     */
    function writeCommand(cmd) {
        // Protocolo bspwm: arg1\0arg2\0arg3\0
        var args = cmd.split(" ")

        // Construir mensaje completo
        var message = ""
        for (var i = 0; i < args.length; i++) {
            message += args[i] + "\0"
        }

        bspwmSocket.write(message)
        bspwmSocket.flush()
    }

    /**
     * Maneja mensajes entrantes del socket principal.
     * @param {string} message - Mensaje recibido
     */
    function handleMessage(message) {
        message = message.trim()

        if (message === "") return

        // Si empieza con "Unknown" es un error
        if (message.startsWith("Unknown")) {
            return
        }

        // Respuestas a queries
        handleQueryResponse(message)
    }

    /**
     * Maneja eventos del socket de suscripción.
     * @param {string} message - Evento recibido
     */
    function handleEvent(message) {
        message = message.trim()

        if (message === "") return

        // Eventos de suscripción (formato: event_name data)
        if (message.startsWith("desktop_focus")) {
            handleDesktopFocus(message)
        } else if (message.startsWith("desktop_layout")) {
            handleDesktopLayout(message)
        } else if (message.startsWith("node_add")) {
            handleNodeAdd(message)
        } else if (message.startsWith("node_remove")) {
            handleNodeRemove(message)
        } else if (message.startsWith("node_transfer")) {
            handleNodeTransfer(message)
        }
    }

    /**
     * Maneja respuestas a queries basadas en el tipo actual.
     * @param {string} message - Respuesta del query
     */
    function handleQueryResponse(message) {
        if (currentQueryType === "") {
            // Respuesta no esperada o evento
            return
        }

        var parts = currentQueryType.split(":")
        var queryType = parts[0]
        var monitor = parts[1] || ""

        if (queryType === "workspaces") {
            var names = message.split("").filter(n => n.trim() !== "")
            if (!workspaceData[monitor]) workspaceData[monitor] = {}
            workspaceData[monitor].names = names
            workspacesUpdated(monitor)
        } else if (queryType === "workspace_ids") {
            var parts = message.split("0x").slice(1)
            var ids = parts.map(p => "0x" + p.substring(0, 8))
            if (!workspaceData[monitor]) workspaceData[monitor] = {}
            workspaceData[monitor].ids = ids
            workspacesUpdated(monitor)
        } else if (queryType === "occupied") {
            var occupied = message.split("").filter(o => o.trim() !== "")
            if (!workspaceData[monitor]) workspaceData[monitor] = {}
            workspaceData[monitor].occupied = occupied
            workspacesUpdated(monitor)
        } else if (queryType === "focused") {
            var focused = message.trim()
            if (!workspaceData[monitor]) workspaceData[monitor] = {}
            workspaceData[monitor].focused = focused
            workspacesUpdated(monitor)
        } else if (queryType === "layout") {
            try {
                var json = JSON.parse(message)
                var layout = json.userLayout || "tiled"
                layoutChanged(layout, currentDesktop || "focused")
            } catch (e) {
                // Ignorar errores de parsing
            }
        } else if (queryType === "monitor_ids") {
            var ids = message.split("\n").filter(l => l.trim() !== "")
            sendCommand("query -M --names", "monitor_names")
            // Store ids temporarily
            tempMonitorIds = ids
        } else if (queryType === "monitor_names") {
            var names = message.split("\n").filter(l => l.trim() !== "")
            monitorData = {}
            for (var i = 0; i < Math.min(tempMonitorIds.length, names.length); i++) {
                monitorData[names[i].trim()] = tempMonitorIds[i].trim()
            }
        }

        currentQueryType = ""
    }

    // === MANEJADORES DE EVENTOS ===

    /**
     * Maneja evento de cambio de foco de desktop.
     * @param {string} message - Mensaje del evento
     */
    function handleDesktopFocus(message) {
        // Formato: desktop_focus <monitor_id> <desktop_id> <desktop_name>
        var parts = message.split(" ")
        if (parts.length >= 3) {
            var monitorId = parts[1]
            var desktopId = parts[2]
            var desktopName = parts[3] || ""
            desktopFocused(monitorId, desktopId, desktopName)
        }
    }

    /**
     * Maneja evento de cambio de layout de desktop.
     * @param {string} message - Mensaje del evento
     */
    function handleDesktopLayout(message) {
        // Formato: desktop_layout <monitor_id> <desktop_id> <layout>
        var parts = message.split(" ")
        if (parts.length >= 4) {
            var monitorId = parts[1]
            var desktopId = parts[2]
            var layout = parts[3]
            desktopLayoutChanged(monitorId, desktopId, layout)
        }
    }

    /**
     * Maneja evento de adición de nodo (ventana).
     * @param {string} message - Mensaje del evento
     */
    function handleNodeAdd(message) {
        // Formato: node_add <monitor_id> <desktop_id> <node_id>
        nodeChanged()
    }

    /**
     * Maneja evento de remoción de nodo (ventana).
     * @param {string} message - Mensaje del evento
     */
    function handleNodeRemove(message) {
        // Formato: node_remove <monitor_id> <desktop_id> <node_id>
        nodeChanged()
    }

    /**
     * Maneja evento de transferencia de nodo entre desktops/monitores.
     * @param {string} message - Mensaje del evento
     */
    function handleNodeTransfer(message) {
        // Formato: node_transfer <src_monitor> <src_desktop> <src_node> <dst_monitor> <dst_desktop> <dst_node>
        nodeChanged()
    }

    // === SEÑALES ===
    signal workspacesUpdated(string monitor)
    signal layoutChanged(string layout, string type)
    signal desktopFocused(string monitorId, string desktopId, string desktopName)
    signal desktopLayoutChanged(string monitorId, string desktopId, string layout)
    signal nodeChanged()

    Component.onCompleted: {
        // Query monitores al inicio
        BspSocket.queryMonitors()

        // Activar socket de eventos para updates en tiempo real
        Qt.callLater(() => {
            bspwmEventSocket.connected = true
        })
    }
}