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
import QtQuick
import Quickshell.Io

// Globales
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

    // Función para modificar una línea específica manteniendo el formato
    // file: Archivo .conf
    // line: Número de línea a modificar
    // key: Clave para verificar (y mantener indentación/formato)
    // value: Nuevo valor
    function setConfig(file, line, key, value) {
        var filePath = Qt.resolvedUrl(picomDir + file).toString().replace("file://", "")
        
        // sed -i 'Ns/^\(\s*key\s*=\s*\)[^;]*/\1value/' file
        // Busca en la línea 'line', si coincide con 'key = ...', reemplaza el valor conservando lo previo.
        var cmd = "sed -i '" + line + "s/^\\(\\s*" + key + "\\s*=\\s*\\)[^;]*/\\1" + value + "/' " + filePath

        var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root)
        proc.command = ["sh", "-c", cmd]
        proc.running = true
        proc.onExited.connect(() => proc.destroy())
    }

    // --- Funciones Específicas ---

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

    // Transpacency Control (0.0 -> 1.0)
    function setTransparency(inactive, active) {
        setConfig("transparency.conf", 27, "opacity", inactive)
        setConfig("transparency.conf", 33, "opacity", active)
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Cargar QML Settings | |
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

    // Matar el proceso de Picom si esta en Ejecución.
    property Process killPicom: Process {
        command: ["killall", "-q", "picom"]
        onExited: startPicom.running = true
    }

    // Arrancar Picom con el archivo de configuración.
    property Process startPicom: Process {
        command: ["picom", "--config", picomFile.toString().replace("file://", "")]
        
        // Logs para depuración en la consola de Quickshell
        stdout: SplitParser { onRead: data => console.log("[Picom]: " + data) }
        stderr: SplitParser { onRead: data => console.error("[Picom Error]: " + data) }
    }

    Component.onCompleted: {
        console.log("[Picom]: Gestionando ciclo de vida.")
        killPicom.running = true
        updatePicomSettings()
    }
}