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
import Quickshell.Hyprland

// Global
import qs.config

QtObject {
    id: root

    // Propiedad pública para saber si Hyprland está activo
    property bool isActive: false

    // === FUNCIONES PÚBLICAS ===

    /**
     * Envía un comando "keyword" a Hyprland.
     * @param {string} cmd - El comando completo (ej. "general:gaps_out 20")
     */
    function sendCommand(cmd) {
        if (isActive) {
            // Usamos el singleton de Hyprland para despachar comandos
            // Usamos 'exec' para llamar a hyprctl ya que 'keyword' no es un dispatcher directo
            Hyprland.dispatch("exec hyprctl keyword " + cmd)
        }
    }

    /**
     * Establece los gaps_out (márgenes externos).
     * Hyprland acepta formato: top,right,bottom,left
     */
    function setGaps(top, right, bottom, left) {
        var gaps = top + "," + right + "," + bottom + "," + left
        sendCommand("general:gaps_out " + gaps)
    }

    /**
     * Convierte color Hex (#RRGGBB o #AARRGGBB) a formato Hyprland 0xAARRGGBB.
     * Qt usa #AARRGGBB, que coincide con el formato legacy de Hyprland 0xAARRGGBB.
     */
    function toHyprColor(c) {
        var col = c.toString()
        if (col.startsWith("#")) {
            col = col.substring(1)
        }

        // RRGGBB -> 0xffRRGGBB (Opaco)
        if (col.length === 6) {
            return "0xff" + col
        }

        // AARRGGBB -> 0xAARRGGBB
        if (col.length === 8) {
            return "0x" + col
        }

        return "0xff" + col
    }

    function setBorderSize(size) {
        sendCommand("general:border_size " + size)
    }

    function setBorderColors(active, inactive) {
        sendCommand("general:col.active_border " + toHyprColor(active))
        sendCommand("general:col.inactive_border " + toHyprColor(inactive))
    }

    function setRounding(radius) {
        sendCommand("decoration:rounding " + radius)
    }

    function setShadows(enabled) {
        sendCommand("decoration:shadow:enabled " + enabled)
    }

    function setShadowColor(color) {
        sendCommand("decoration:shadow:color " + toHyprColor(color))
    }

    function inactiveOpacity(value) {
        sendCommand("decoration:inactive_opacity " + value)
    }

    function activeOpacity(value) {
        sendCommand("decoration:active_opacity " + value)
    }

    function setBlur(enabled) {
        sendCommand("decoration:blur:enabled " + enabled)
    }

    function setFading(enabled) {
        if (enabled) {
            sendCommand("animation fade, 1")
        } else {
            sendCommand("animation fade,0")
        }
    }

    /**
     * Lee la configuración global y la aplica a Hyprland.
     */
    function updateHyprlandSettings() {
        if (!isActive) return

        // Establecer gaps (con fix del wallborder)
        setGaps(
            Config.global.margins, 
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0), 
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0), 
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0)
        )

        // Bordes
        setBorderSize(Config.windows.borderWidth)
        setBorderColors(Config.windows.focusedColor, Config.windows.activeColor)

        // Corner Radius, (calculo Automatico para Hug Corners)
        setRounding(Config.global.corners - Config.global.margins)

        // Shadows
        setShadows(Config.shadows.enabled)
        setShadowColor(Config.shadows.color)

        // Active/Inactive Opacity
        inactiveOpacity(Config.windows.inactiveOpacity)
        activeOpacity(Config.windows.activeOpacity)

        // Blur
        setBlur(Config.windows.enableBlur)

        // Fading
        setFading(Config.windows.enableFading)
    }

    // === INICIALIZACIÓN ===

    Component.onCompleted: {
        // Verificar si estamos en Hyprland
        var session = (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()
        
        if (session.indexOf("hyprland") !== -1) {
            isActive = true
            updateHyprlandSettings()
        }
    }
}