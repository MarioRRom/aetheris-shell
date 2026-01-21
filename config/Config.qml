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

QtObject {

    // Configuración global de Shadows.
    property QtObject shadows: QtObject {
        property bool enabled: true // Activar sombras.
        property var color: Qt.rgba(0, 0, 0, 0.5) // Color de las sombras.
    }

    // Estado global de la barra superior
    property QtObject topBar: QtObject {
        property string state: "maximized" // float o maximized.
        property int height: 36 // Tamaño de la barra

        // para floating
        property int corners: 25 // radius
        property int margin: 10 // margen desde el borde
        
        // para maximized
        property bool hug: true // activar hug.
        property int hugsize: 30 // Tamaño de los Corners
        property int wallborder: 0 // Bordeado del Escritorio
    }


    // Configuracion Global
    property QtObject global: QtObject {
        property int corners: 30 // radius
        property int margins: 10 // margen desde el borde
    }

    // Theme Manager
    property QtObject theme: QtObject {
        property string colorscheme: "mocha" // latte, frappe, macchiato, mocha
        property string mainfont: "Sofia Pro" // fuente principal del sistema
        property string iconfont: "Material Design Icons Desktop" // fuente de iconos
    }
}