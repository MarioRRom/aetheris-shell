//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝                                                                          
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
//===========================================================================


pragma Singleton
import QtQuick
import qs.config
import qs.themes.colorschemes as Colorschemes

QtObject {
    id: themeManager

    // Tema activo
    property string currentScheme: Config.theme.colorscheme // latte, frappe, macchiato, mocha

    // Instancias de cada esquema
    readonly property var latte: Colorschemes.Latte {}
    readonly property var frappe: Colorschemes.Frappe {}
    readonly property var macchiato: Colorschemes.Macchiato {}
    readonly property var mocha: Colorschemes.Mocha {}

    // Getter dinámico de colores según esquema
    readonly property var colors: {
        switch(currentScheme) {
            case "latte": return latte
            case "frappe": return frappe
            case "macchiato": return macchiato
            case "mocha": return mocha
            default: return mocha
        }
    }

    // Configuración de fuentes
    readonly property var fonts: QtObject {
        readonly property string main: Config.theme.mainfont // fuente principal del sistema
        readonly property string icons: Config.theme.iconfont // fuente de iconos
    }
}
