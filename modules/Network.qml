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

    // Estado del Wi-Fi por Hardware.
    readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled

    // Estado del Wi-Fi por Software.
    readonly property bool wifiEnabled: Networking.wifiEnabled


    // .-------------------------.
    // | .---------------------. |
    // | |    Wired Device     | |
    // | `---------------------' |
    // `-------------------------'

    // cable conectado (si hay alguno).
    readonly property WiredDevice wiredDevice: {
        for (const dev of Networking.devices.values)
            if (dev.type === DeviceType.Wired) return dev as WiredDevice
        return null
    }

    // Estado de conexion a la red Cableada.
    readonly property bool wiredConnected: wiredDevice?.connected ?? false

    // Velocidad de la Conexión.
    readonly property int wiredSpeed: wiredDevice?.linkSpeed ?? 0

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

    // Activar/Desactivar wifi (Software)
    function toggleWifi()                   { Networking.wifiEnabled = !Networking.wifiEnabled }

    // Conectar a una red
    function connectToNetwork(network, password = "") {
        if (!network) return
        password ? network.connectWithPsk(password) : network.connect()
    }

    // Desconectar de una red
    function disconnectFromNetwork(network) { if (network) network.disconnect() }

    // Olvidar una red
    function forgetNetwork(network)         { if (network) network.forget()      }


    // .-------------------------.
    // | .---------------------. |
    // | |     UI Helpers      | |
    // | `---------------------' |
    // `-------------------------'

    // Intensidad de señal Wifi
    function signalIcon(network) {
        if (!network) return "󰤭"  // wifi-strength-off-outline
        const s = network.signalStrength
        if (s > 0.75) return "󰤨"  // wifi-strength-4
        if (s > 0.50) return "󰤥"  // wifi-strength-3  
        if (s > 0.25) return "󰤢"  // wifi-strength-2
        return "󰤟"                // wifi-strength-1
    }
    
    // Intensidad de señal Wifi (Protegido)
    function signalIconLocked(network) {
        if (!network) return "󰤭"  // wifi-strength-off-outline
        const s = network.signalStrength
        if (s > 0.75) return "󰤪"  // wifi-strength-4
        if (s > 0.50) return "󰤧"  // wifi-strength-3  
        if (s > 0.25) return "󰤤"  // wifi-strength-2
        return "󰤡"  
    }

    // verificar si esta Protegida
    function isSecured(network) {
        return !!network && network.security !== WifiSecurityType.Open
    }

    // Icono de estado de Red
    readonly property string statusIcon: {
        if (wiredConnected) return "󰈀"
        if (!wifiHardwareEnabled) return "󰤮"
        if (!wifiEnabled)         return "󰤮"
        if (!wifiConnected)       return "󰤭"
        if (connectivity === NetworkConnectivity.Portal)  return "󰤬"
        if (connectivity === NetworkConnectivity.Limited) return "󰤫"
        return signalIcon(activeNetwork)
    }

    // Texto descriptivo de estado de red
    readonly property string statusText: {
        if (wiredConnected)                               return "Ethernet"
        if (!wifiHardwareEnabled)                         return "Wi-Fi bloqueado (hardware)"
        if (!wifiEnabled)                                 return "Wi-Fi desactivado"
        if (!wifiConnected)                               return "Desconectado"
        if (connectivity === NetworkConnectivity.Portal)  return "Portal cautivo"
        if (connectivity === NetworkConnectivity.Limited) return "Sin internet"
        return ssid
    }
}