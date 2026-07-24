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
pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick
import Quickshell.Hyprland

// Global
import qs.config

QtObject {
    id: root

    // Public property to know if Hyprland is active
    property bool isActive: false

    // Injected by shell.qml on startup with the session identifier.
    property string session: ""
    onSessionChanged: {
        if (session.indexOf("hyprland") !== -1) {
            isActive = true
            updateHyprlandSettings()
        }
    }

    // Clamped rounding: prevents negative values from breaking Hyprland
    property int rounding: Math.max(0, Config.global.corners - Config.global.margins)


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Public Functions   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Sends a "keyword" command to Hyprland.
    // @param {string} cmd - The full command (e.g. "general:gaps_out 20")
    function sendCommand(cmd) {
        if (isActive) {
            // Use the Hyprland singleton to dispatch commands
            // Use 'exec' to call hyprctl since 'keyword' is not a direct dispatcher
            Hyprland.dispatch("exec hyprctl keyword " + cmd)
        }
    }

    // Sets the gaps_out (external margins).
    // Hyprland accepts format: top,right,bottom,left
    function setGaps(top, right, bottom, left) {
        var gaps = top + "," + right + "," + bottom + "," + left
        sendCommand("general:gaps_out " + gaps)
    }

    // Converts Hex color (#RRGGBB or #AARRGGBB) to Hyprland format 0xAARRGGBB.
    // Qt uses #AARRGGBB, which matches Hyprland's legacy format 0xAARRGGBB.
    function toHyprColor(c) {
        var col = c.toString()
        if (col.startsWith("#")) {
            col = col.substring(1)
        }

        // RRGGBB -> 0xffRRGGBB (Opaque)
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
            sendCommand("animation fade,1")
        } else {
            sendCommand("animation fade,0")
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Apply Settings    | |
    //  | `---------------------' |
    //  `-------------------------'

    function updateHyprlandSettings() {
        if (!isActive) return

        // Set gaps (with wallborder fix)
        setGaps(
            Config.global.margins,
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0),
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0),
            Config.global.margins + (Config.topBar.state === "maximized" ? Config.global.wallborder : 0)
        )

        // Borders
        setBorderSize(Config.windows.borderWidth)
        setBorderColors(Config.windows.focusedBorderColor, Config.windows.unfocusedBorderColor)

        // Corner Radius (clamped to non-negative)
        setRounding(root.rounding)

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
}