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

// This is my Socket proposal for Bspwm. 
// Gets Workspaces and states per monitor, also the layout.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Config
import qs.config

QtObject {
    id: root

    // Public property so widgets know if BSPWM is active
    property bool isActive: false

    // bspwm socket (for commands)
    property Socket socket: Socket {
        id: bspwmSocket
        
        path: {
            var display = Quickshell.env("DISPLAY") || ":0"
            var displayNum = display.replace(":", "").split(".")[0]
            return "/tmp/bspwm_" + displayNum + "_0-socket"
        }
        
        connected: false
        
        // Buffer to accumulate the complete response
        property string responseBuffer: ""
        
        parser: SplitParser {
            onRead: (message) => {
                // Accumulate in buffer (response may come in chunks)
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

                // Reset state
                processingCommand = false
                currentQueryType = ""
                Qt.callLater(() => {
                    processQueue()
                })
            }
        }

        onError: (error) => {
            // Error 1 = PeerClosedError (normal, bspwm closes after responding)
            // Other errors are silently ignored
        }
    }

    // Socket dedicated for events (subscribe)
    property Socket eventSocket: Socket {
        id: bspwmEventSocket
        
        path: bspwmSocket.path
        connected: false  // Activate manually when needed
        
        parser: SplitParser {
            onRead: (message) => {
                root.handleEvent(message)
            }
        }

        onConnectedChanged: {
            if (connected) {
                // Subscribe to events
                Qt.callLater(() => {
                    subscribeToEvents()
                })
            }
        }
    }

    // Subscribe to events (keeps connection open)
    function subscribeToEvents() {
        if (!bspwmEventSocket.connected) return
        
        var cmd = "subscribe desktop_focus desktop_layout node_add node_remove node_transfer"
        var args = cmd.split(" ")
        
        // bspwm protocol: arg1\0arg2\0arg3\0
        for (var i = 0; i < args.length; i++) {
            bspwmEventSocket.write(args[i] + "\0")
        }
        bspwmEventSocket.flush()
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Internal State    | |
    //  | `---------------------' |
    //  `-------------------------'

    property var workspaceData: ({})
    property var layoutData: ({})
    property var monitorData: ({})
    property var tempMonitorIds: []
    property string currentDesktop: ""
    property int windowGap: 10
    property int topPadding: 0
    property int bottomPadding: 0
    property int leftPadding: 0
    property int rightPadding: 0
    property int borderWidth: 0
    property string activeBorderColor: ""
    property string focusedBorderColor: ""
    
    // Command queue with type
    property var commandQueue: []
    property bool processingCommand: false
    property string currentQueryType: ""
    

    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Public Functions   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Queries workspace names of a specific monitor.
    // @param {string} monitor - Monitor name (e.g. "HDMI-A-0")
    function queryWorkspaces(monitor) {
        sendCommand("query -D -m " + monitor + " --names", "workspaces:" + monitor)
    }

    // Queries hex IDs of workspaces on a monitor.
    // @param {string} monitor - Monitor name
    function queryWorkspaceIds(monitor) {
        sendCommand("query -D -m " + monitor, "workspace_ids:" + monitor)
    }

    // Queries occupied workspaces (with windows) on a monitor.
    // @param {string} monitor - Monitor name
    function queryOccupiedWorkspaces(monitor) {
        sendCommand("query -D -m " + monitor + " -d .occupied --names", "occupied:" + monitor)
    }

    // Queries the focused workspace on a monitor.
    // @param {string} monitor - Monitor name
    function queryFocusedWorkspace(monitor) {
        sendCommand("query -D -m " + monitor + " -d focused --names", "focused:" + monitor)
    }

    // Switches focus to the desktop specified by ID.
    // @param {string} desktopId - Hex ID of the desktop (e.g. "0x00200012")
    function switchDesktop(desktopId) {
        sendCommand("desktop " + desktopId + " -f", "")
    }

    // Toggles the layout of the current desktop (tiled <-> monocle).
    function toggleLayout() {
        sendCommand("desktop -l next", "")
        // Re-query layout after toggle
        Qt.callLater(() => queryLayout(), 100)
    }

    // Queries the layout of the specified desktop or the focused one.
    // @param {string} [desktop] - Desktop ID (optional, defaults to focused)
    function queryLayout(desktop) {
        if (desktop) {
            sendCommand("query -T -d " + desktop, "layout")
        } else {
            sendCommand("query -T -d focused", "layout")
        }
    }

    // Sets the global window_gap.
    // @param {int} gap - Gap size in pixels
    function setWindowGap(gap) {
        sendCommand("config window_gap " + gap, "")
        windowGap = gap
    }

    // Sets the global top_padding.
    // @param {int} padding - Top padding size in pixels
    function setTopPadding(padding) {
        sendCommand("config top_padding " + padding, "")
        topPadding = padding
    }

    // Sets the global bottom_padding.
    // @param {int} padding - Bottom padding size in pixels
    function setBottomPadding(padding) {
        sendCommand("config bottom_padding " + padding, "")
        bottomPadding = padding
    }

    // Sets the global left_padding.
    // @param {int} padding - Left padding size in pixels
    function setLeftPadding(padding) {
        sendCommand("config left_padding " + padding, "")
        leftPadding = padding
    }

    // Sets the global right_padding.
    // @param {int} padding - Right padding size in pixels
    function setRightPadding(padding) {
        sendCommand("config right_padding " + padding, "")
        rightPadding = padding
    }

    // Sets the global border_width.
    // @param {int} width - Border width in pixels
    function setBorderWidth(width) {
        sendCommand("config border_width " + width, "")
        borderWidth = width
    }

    // Sets the global active_border_color.
    // @param {string} color - Color in hex format (e.g. "#RRGGBB")
    function setActiveBorderColor(color) {
        sendCommand("config active_border_color " + color, "")
        activeBorderColor = color
    }

    // Sets the global focused_border_color.
    // @param {string} color - Color in hex format (e.g. "#RRGGBB")
    function setFocusedBorderColor(color) {
        sendCommand("config focused_border_color " + color, "")
        focusedBorderColor = color
    }

    // Queries the list of available monitors.
    function queryMonitors() {
        sendCommand("query -M", "monitor_ids")
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Internal Functions  | |
    //  | `---------------------' |
    //  `-------------------------'

    // Sends a command to the bspwm socket with a type for tracking.
    // @param {string} cmd - bspwm command (e.g. "query -D -m HDMI-A-0 --names")
    // @param {string} type - Query type for response handling (e.g. "workspaces:HDMI-A-0")
    function sendCommand(cmd, type) {
        commandQueue.push({cmd: cmd, type: type})
        processQueue()
    }

    // Processes the command queue sequentially.
    // Handles automatic reconnection if the socket is not connected.
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
    
    // Writes the command to the socket using the bspwm protocol.
    // Format: arg1\0arg2\0arg3\0 (null-terminated strings)
    // @param {string} cmd - Command to send
    function writeCommand(cmd) {
        // bspwm protocol: arg1\0arg2\0arg3\0
        var args = cmd.split(" ")

        // Build complete message
        var message = ""
        for (var i = 0; i < args.length; i++) {
            message += args[i] + "\0"
        }

        bspwmSocket.write(message)
        bspwmSocket.flush()
    }

    // Handles incoming messages from the main socket.
    // @param {string} message - Received message
    function handleMessage(message) {
        message = message.trim()

        if (message === "") return

        // If it starts with "Unknown" it's an error
        if (message.startsWith("Unknown")) {
            return
        }

        // Query responses
        handleQueryResponse(message)
    }

    // Handles events from the subscription socket.
    // @param {string} message - Received event
    function handleEvent(message) {
        message = message.trim()

        if (message === "") return

        // Subscription events (format: event_name data)
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

    // Handles query responses based on the current type.
    // @param {string} message - Query response
    function handleQueryResponse(message) {
        if (currentQueryType === "") {
            // Unexpected response or event
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
                // Ignore parsing errors
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


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Event Handlers    | |
    //  | `---------------------' |
    //  `-------------------------'

    // Handles desktop focus change event.
    // @param {string} message - Event message
    function handleDesktopFocus(message) {
        // Format: desktop_focus <monitor_id> <desktop_id> <desktop_name>
        var parts = message.split(" ")
        if (parts.length >= 3) {
            var monitorId = parts[1]
            var desktopId = parts[2]
            var desktopName = parts[3] || ""
            desktopFocused(monitorId, desktopId, desktopName)
        }
    }

    // Handles desktop layout change event.
    // @param {string} message - Event message
    function handleDesktopLayout(message) {
        // Format: desktop_layout <monitor_id> <desktop_id> <layout>
        var parts = message.split(" ")
        if (parts.length >= 4) {
            var monitorId = parts[1]
            var desktopId = parts[2]
            var layout = parts[3]
            desktopLayoutChanged(monitorId, desktopId, layout)
        }
    }

    // Handles node add (window) event.
    // @param {string} message - Event message
    function handleNodeAdd(message) {
        // Format: node_add <monitor_id> <desktop_id> <node_id>
        nodeChanged()
    }

    // Handles node remove (window) event.
    // @param {string} message - Event message
    function handleNodeRemove(message) {
        // Format: node_remove <monitor_id> <desktop_id> <node_id>
        nodeChanged()
    }

    // Handles node transfer event between desktops/monitors.
    // @param {string} message - Event message
    function handleNodeTransfer(message) {
        // Format: node_transfer <src_monitor> <src_desktop> <src_node> <dst_monitor> <dst_desktop> <dst_node>
        nodeChanged()
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |       Signals       | |
    //  | `---------------------' |
    //  `-------------------------'

    signal workspacesUpdated(string monitor)
    signal layoutChanged(string layout, string type)
    signal desktopFocused(string monitorId, string desktopId, string desktopName)
    signal desktopLayoutChanged(string monitorId, string desktopId, string layout)
    signal nodeChanged()


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Internal Config   | |
    //  | `---------------------' |
    //  `-------------------------'

    function updateBspwmSettings() {
        // Gap
        setWindowGap(Config.global.margins)
        
        // Padding (for WallBorder)
        if (Config.topBar.state === "maximized") {
            setTopPadding(Config.topBar.height)
            setBottomPadding(Config.global.wallborder)
            setLeftPadding(Config.global.wallborder)
            setRightPadding(Config.global.wallborder)
        } else {
            setTopPadding(Config.topBar.height + Config.global.margins)
            setBottomPadding(0)
            setLeftPadding(0)
            setRightPadding(0)
        }

        // Border
        setBorderWidth(Config.windows.borderWidth)
        setActiveBorderColor(Config.windows.activeColor)
        setFocusedBorderColor(Config.windows.focusedColor)
    }

    Component.onCompleted: {
        // Check if we are in bspwm
        var session = (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()
        if (session !== "bspwm") return

        isActive = true

        // Query monitors at startup
        queryMonitors()

        // Set Internal Configuration
        updateBspwmSettings()

        // Activate event socket for real-time updates
        Qt.callLater(() => {
            bspwmEventSocket.connected = true
        })
    }
}