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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

QtObject {
    id: root


    // .-------------------------.
    // | .---------------------. |
    // | |  Networking Status  | |
    // | `---------------------' |
    // `-------------------------'
    
    // Conectividad (Portal, Limited, Unknown, Full, None )
    readonly property var connectivity: Networking.connectivity
    
    // ¿Tenemos acceso a internet?
    readonly property bool hasInternet: connectivity === NetworkConnectivity.Full


    // Estado del Wi-Fi por Hardware.
    readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled

    // Estado del Wi-Fi por Software. (r/w)
    property bool wifiEnabled: Networking.wifiEnabled


    // .-------------------------.
    // | .---------------------. |
    // | |    Wi-Fi Device     | |
    // | `---------------------' |
    // `-------------------------'

    // Lista de redes disponibles.
    readonly property var networkList: wifiDevice?.networks.values ?? []

    // El adaptador Wi-Fi activo (si hay alguno).
    readonly property WifiDevice wifiDevice: {
        const devList = Networking.devices.values
        for (const dev of devList) {
            if (dev.type === DeviceType.Wifi)
                return dev as WifiDevice
        }
        return null
    }

    // Estado de conexión a la red Wi-Fi.
    readonly property bool wifiConnected: wifiDevice?.connected ?? false


    // .-------------------------.
    // | .---------------------. |
    // | |  Connected Network  | |
    // | `---------------------' |
    // `-------------------------'

    // La red Wi-Fi actualmente conectada (si hay alguna).
    readonly property WifiNetwork activeNetwork: networkList.find(n => n.connected) ?? null
    
    // Propiedades convenientes para mostrar en la UI.
    readonly property string ssid:           activeNetwork?.name           ?? ""
    readonly property real   signalStrength: activeNetwork?.signalStrength ?? 0.0
    readonly property int    signalPercent:  Math.round(signalStrength * 100)


    // .-------------------------.
    // | .---------------------. |
    // | |    Wi-Fi Scanner    | |
    // | `---------------------' |
    // `-------------------------'

    readonly property bool scannerActive: wifiDevice?.scannerEnabled ?? false

    function enableScan()  { if (wifiDevice) wifiDevice.scannerEnabled = true  }
    function disableScan() { if (wifiDevice) wifiDevice.scannerEnabled = false }


    // .-------------------------.
    // | .---------------------. |
    // | |    Wi-Fi Actions    | |
    // | `---------------------' |
    // `-------------------------'

    function toggleWifi()                   { wifiEnabled = !wifiEnabled }
    function connectToNetwork(network)      { if (network) network.connect()    }
    function disconnectFromNetwork(network) { if (network) network.disconnect() }
    function disconnectActive()             { if (activeNetwork) activeNetwork.disconnect() }
    function forgetNetwork(network)         { if (network) network.forget()      }


    // .-------------------------.
    // | .---------------------. |
    // | |     UI Helpers      | |
    // | `---------------------' |
    // `-------------------------'

    // Helper universal: recibe cualquier WifiNetwork
    function networkIcon(network) {
        if (!network) return "󰤭"  // 󰤖 wifi-strength-off-outline
        const s = network.signalStrength
        if (s > 0.75) return "󰤨"  // 󰤓 wifi-strength-4
        if (s > 0.50) return "󰤥"  // 󰤐 wifi-strength-3  
        if (s > 0.25) return "󰤢"  // 󰤍 wifi-strength-2
        return "󰤟"                // 󰤊 wifi-strength-1
    }

    function networkPercent(network) {
        return network ? Math.round(network.signalStrength * 100) : 0
    }

    readonly property string wifiIcon: {
        if (!wifiHardwareEnabled) {
            if (connectivity === NetworkConnectivity.Full) return "󰈀"
            return "󰤮"
        }
        if (!wifiEnabled){
            if (connectivity === NetworkConnectivity.Full) return "󰈀"
            return "󰤭"
        }
        if (!wifiConnected){
            if (connectivity === NetworkConnectivity.Full) return "󰈀"
            return "󰤫"
        }
        if (connectivity === NetworkConnectivity.Portal)  return "󰤬"
        if (connectivity === NetworkConnectivity.Limited) return "󰤫"
        return networkIcon(activeNetwork)  // delega en el helper universal
    }

    readonly property string statusText: {
        if (!wifiHardwareEnabled)                        return "Wi-Fi bloqueado (hardware)"
        if (!wifiEnabled)                                return "Wi-Fi desactivado"
        if (!wifiConnected)                              return "Desconectado"
        if (connectivity === NetworkConnectivity.Portal) return "Portal cautivo"
        if (connectivity === NetworkConnectivity.Limited) return "Sin internet"
        return ssid
    }


    // .-------------------------.
    // | .---------------------. |
    // | |     Debug Logs      | |
    // | `---------------------' |
    // `-------------------------'

    Component.onCompleted: {
        const connectivityNames = { 0: "Unknown", 1: "None", 2: "Portal", 3: "Limited", 4: "Full" }
        const modeNames         = { 0: "Unknown", 1: "Infrastructure", 2: "AdHoc", 3: "AP" }
        const securityNames     = { 0: "None", 1: "Wpa", 2: "Wpa2Enterprise", 3: "Wpa2", 4: "Wpa3" }
        const deviceTypeNames   = { 0: "Unknown", 1: "Wifi", 2: "Ethernet", 3: "Other" }

        console.log("═══════════════════════════════════")
        console.log("       NetworkService · Init        ")
        console.log("═══════════════════════════════════")

        const devList = Networking.devices.values
        console.log("[Hardware]  wifiHardwareEnabled :", wifiHardwareEnabled)
        console.log("[Hardware]  wifiEnabled         :", wifiEnabled)
        console.log("[Hardware]  devices.count       :", devList.length)

        for (let i = 0; i < devList.length; i++) {
            const d = devList[i]
            console.log(`[Device ${i}]  type=${deviceTypeNames[d.type] ?? d.type}  name=${d.name}  connected=${d.connected}`)
        }

        console.log("[Status]    connectivity         :", connectivityNames[connectivity] ?? connectivity)
        console.log("[Status]    hasInternet          :", hasInternet)

        if (wifiDevice) {
            console.log("[WifiDev]   name                :", wifiDevice.name)
            console.log("[WifiDev]   connected           :", wifiDevice.connected)
            console.log("[WifiDev]   mode                :", modeNames[wifiDevice.mode] ?? wifiDevice.mode)
            console.log("[WifiDev]   networks.count      :", networkList.length)
        } else {
            console.log("[WifiDev]   ⚠ null — no se encontró adaptador Wi-Fi")
        }

        if (activeNetwork) {
            console.log("[Network]   ssid                :", ssid)
            console.log("[Network]   signalStrength       :", signalStrength, "(" + signalPercent + "%)")
            console.log("[Network]   known               :", activeNetwork.known)
            console.log("[Network]   security            :", securityNames[activeNetwork.security] ?? activeNetwork.security)
        } else {
            console.log("[Network]   ⚠ null — no hay red conectada")
        }

        console.log("[Scanner]   scannerActive        :", scannerActive)
        console.log("═══════════════════════════════════")
    }
}