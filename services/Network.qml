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
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

// Config
import qs.i18n

QtObject {
    id: root


    // .-------------------------.
    // | .---------------------. |
    // | |  Networking Status  | |
    // | `---------------------' |
    // `-------------------------'
    
    // Connectivity (Portal, Limited, Unknown, Full, None)
    readonly property var connectivity: Networking.connectivity

    // Wi-Fi hardware state.
    readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled

    // Wi-Fi software state.
    readonly property bool wifiEnabled: Networking.wifiEnabled


    // .-------------------------.
    // | .---------------------. |
    // | |    Wired Device     | |
    // | `---------------------' |
    // `-------------------------'

    // cable connected (if any).
    readonly property WiredDevice wiredDevice: {
        for (const dev of Networking.devices.values)
            if (dev.type === DeviceType.Wired) return dev as WiredDevice
        return null
    }

    // Wired network connection state.
    readonly property bool wiredConnected: wiredDevice?.connected ?? false

    // Connection speed.
    readonly property int wiredSpeed: wiredDevice?.linkSpeed ?? 0


    // .-------------------------.
    // | .---------------------. |
    // | |    Wi-Fi Device     | |
    // | `---------------------' |
    // `-------------------------'

    // List of available networks.
    readonly property var networkList: wifiDevice?.networks.values ?? []

    // Active Wi-Fi adapter (if any).
    readonly property WifiDevice wifiDevice: {
        const devList = Networking.devices.values
        for (const dev of devList) {
            if (dev.type === DeviceType.Wifi)
                return dev as WifiDevice
        }
        return null
    }

    // Wi-Fi connection state.
    readonly property bool wifiConnected: wifiDevice?.connected ?? false


    // .-------------------------.
    // | .---------------------. |
    // | |  Connected Network  | |
    // | `---------------------' |
    // `-------------------------'

    // The currently connected Wi-Fi network (if any).
    readonly property WifiNetwork activeNetwork: networkList.find(n => n.connected) ?? null
    
    // Convenient properties for displaying in the UI.
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

    // Enable/Disable wifi (Software)
    function toggleWifi()                   { Networking.wifiEnabled = !Networking.wifiEnabled }

    // Connect to a network
    function connectToNetwork(network, password = "") {
        if (!network) return
        password ? network.connectWithPsk(password) : network.connect()
    }

    // Disconnect from a network
    function disconnectFromNetwork(network) { if (network) network.disconnect() }

    // Forget a network
    function forgetNetwork(network)         { if (network) network.forget()      }


    // .-------------------------.
    // | .---------------------. |
    // | |     UI Helpers      | |
    // | `---------------------' |
    // `-------------------------'

    // Wifi signal strength
    function signalIcon(network) {
        if (!network) return "󰤭"  // wifi-strength-off-outline
        const s = network.signalStrength
        if (s > 0.75) return "󰤨"  // wifi-strength-4
        if (s > 0.50) return "󰤥"  // wifi-strength-3  
        if (s > 0.25) return "󰤢"  // wifi-strength-2
        return "󰤟"                // wifi-strength-1
    }
    
    // Wifi signal strength (Secured)
    function signalIconLocked(network) {
        if (!network) return "󰤭"  // wifi-strength-off-outline
        const s = network.signalStrength
        if (s > 0.75) return "󰤪"  // wifi-strength-4
        if (s > 0.50) return "󰤧"  // wifi-strength-3  
        if (s > 0.25) return "󰤤"  // wifi-strength-2
        return "󰤡"  
    }

    // check if it's Secured
    function isSecured(network) {
        return !!network && network.security !== WifiSecurityType.Open
    }

    // Network status icon
    readonly property string statusIcon: {
        if (wiredConnected) return "󰈀"
        if (!wifiHardwareEnabled) return "󰤮"
        if (!wifiEnabled)         return "󰤮"
        if (!wifiConnected)       return "󰤭"
        if (connectivity === NetworkConnectivity.Portal)  return "󰤬"
        if (connectivity === NetworkConnectivity.Limited) return "󰤫"
        return signalIcon(activeNetwork)
    }

    // Descriptive network status text
    readonly property string statusText: {
        if (wiredConnected)                               return LanguageManager.t("network.ethernet")
        if (!wifiHardwareEnabled)                         return LanguageManager.t("network.wifiBlocked")
        if (!wifiEnabled)                                 return LanguageManager.t("network.wifiDisabled")
        if (!wifiConnected)                               return LanguageManager.t("network.disconnected")
        if (connectivity === NetworkConnectivity.Portal)  return LanguageManager.t("network.captivePortal")
        if (connectivity === NetworkConnectivity.Limited) return LanguageManager.t("network.noInternet")
        return ssid
    }
}