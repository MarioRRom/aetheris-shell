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
import QtQuick
import Quickshell.Io

// Config
import qs.config


//  .-------------------------.
//  | .---------------------. |
//  | |    Picom Service    | |
//  | `---------------------' |
//  `-------------------------'

QtObject {
    id: root

    // Config
    property string picomDir: "picom/"
    property string picomFile: Qt.resolvedUrl(picomDir + "picom.conf")


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Settings Editor   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Function to modify a specific line while preserving formatting
    // file: .conf file
    // line: Line number to modify
    // key: Key to verify (and keep indentation/format)
    // value: New value
    function setConfig(file, line, key, value) {
        var filePath = Qt.resolvedUrl(picomDir + file).toString().replace("file://", "")

        // Escape sed-special chars in value (&, /, \) to prevent injection
        var safeValue = value.toString().replace(/[&/\\]/g, "\\$&")

        // sed -i 'Ns/^\(\s*key\s*=\s*\)[^;]*/\1value/' file
        // Search line 'line', if it matches 'key = ...', replace value preserving the previous part.
        var cmd = "sed -i '" + line + "s/^\\(\\s*" + key + "\\s*=\\s*\\)[^;]*/\\1" + safeValue + "/' '" + filePath + "'"

        var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root)
        proc.command = ["sh", "-c", cmd]
        proc.running = true
        proc.onExited.connect(() => proc.destroy())
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Specific Functions  | |
    //  | `---------------------' |
    //  `-------------------------'

    // Blur ON/OFF
    function setBlur(value) {
        setConfig("blur.conf", 27, "blur-background", value)
    }

    // Corners Radius
    function setCorners(value) {
        setConfig("corners.conf", 27, "corner-radius", value)
    }

    // Fading ON/OFF
    function setFading(value) {
        setConfig("fading.conf", 27, "fade", value)
    }

    // Shadows Control (on/off + color)
    function setShadows(value, color) {
        setConfig("shadows.conf", 27, "shadow", value)
        setConfig("shadows.conf", 28, "shadow-color", "\"" + color + "\"")
    }

    // Transparency Control (0.0 -> 1.0)
    function setTransparency(inactive, active) {
        setConfig("transparency.conf", 27, "opacity", inactive)
        setConfig("transparency.conf", 33, "opacity", active)
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Load QML Settings  | |
    //  | `---------------------' |
    //  `-------------------------'

    function updatePicomSettings() {
        setBlur(Config.windows.enableBlur)
        setCorners((Config.global.corners - Config.global.margins))
        setFading(Config.windows.enableFading)
        setShadows(Config.shadows.enabled, Config.shadows.color)
        setTransparency(Config.windows.inactiveOpacity, Config.windows.activeOpacity)
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Picom Process    | |
    //  | `---------------------' |
    //  `-------------------------'

    // Kill the Picom process if it is running.
    property Process killPicom: Process {
        command: ["killall", "-q", "picom"]
        onExited: startPicom.running = true
    }

    // Start Picom with the configuration file.
    property Process startPicom: Process {
        command: ["picom", "--config", picomFile.toString().replace("file://", "")]

        // Logs for debugging in the Quickshell console
        stdout: SplitParser { onRead: data => console.log("[Picom]: " + data) }
        stderr: SplitParser { onRead: data => console.error("[Picom Error]: " + data) }
    }

    Component.onCompleted: {
        killPicom.running = true
        updatePicomSettings()
    }
}