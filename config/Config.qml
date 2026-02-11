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

// Global
import qs.themes

QtObject {

    // Configuración global de Shadows.
    property QtObject shadows: QtObject {
        property bool enabled: true // Activar sombras.
        property var color: "#80000000" // Color de las sombras.
    }

    // Estado global de la barra superior
    property QtObject topBar: QtObject {
        property string state: "maximized" // float o maximized.
        property int height: 36 // Tamaño de la barra, minimo 16 para evitar bugs.

        property bool hug: true // activar hug.
    }

    // Estado global para las Ventanas
    property QtObject windows: QtObject {
        property int borderWidth: 2 // Grosor del borde.
        property color activeColor: ThemeManager.colors.base // Color del borde.
        property color focusedColor: ThemeManager.colors.sky // Color del borde Focuseado.
        property string inactiveOpacity: "0.9" // Opacidad de las ventanas Inactivas.
        property string activeOpacity: "1.0" // Opacidad de las ventanas Activas.
        property bool enableBlur: true // Activar/Desactivar Blur.
        property bool enableFading: true // Activar/Desactivar Fading.

    }

    // Configuracion Global
    property QtObject global: QtObject {
        property int corners: 30 // radius, maximo 40 para prevenir bugs.
        property int margins: 10 // margen desde el borde, maximo 30 para prevenir bugs.
        property int wallborder: 10 // Bordeado del Escritorio
    }

    // Theme Manager
    property QtObject theme: QtObject {
        property string colorscheme: "mocha" // latte, frappe, macchiato, mocha
        property string mainfont: "Sofia Pro" // fuente principal del sistema
        property string iconfont: "Material Design Icons Desktop" // fuente de iconos
    }
}