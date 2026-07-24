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

// Config
import qs.config
import qs.themes.colorschemes as Colorschemes

QtObject {
    id: themeManager

    // Active theme
    property string currentScheme: Config.theme.colorscheme // latte, frappe, macchiato, mocha

    // Instances of each scheme
    readonly property var latte: Colorschemes.Latte {}
    readonly property var frappe: Colorschemes.Frappe {}
    readonly property var macchiato: Colorschemes.Macchiato {}
    readonly property var mocha: Colorschemes.Mocha {}

    // Dynamic color getter based on scheme
    readonly property var colors: {
        switch(currentScheme) {
            case "latte": return latte
            case "frappe": return frappe
            case "macchiato": return macchiato
            case "mocha": return mocha
            default: return mocha
        }
    }

    // Font configuration
    readonly property var fonts: QtObject {
        readonly property string main: Config.theme.mainfont // Text font
    }
}
