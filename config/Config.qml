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

// Config
import qs.themes

QtObject {

    // Global Shadows configuration.
    property QtObject shadows: QtObject {
        property bool enabled: true // Enable shadows.
        property var color: "#80000000" // Shadow color.
    }

    // Global top bar state
    property QtObject topBar: QtObject {
        property string state: "maximized" // float or maximized.
        property int height: 36 // Bar size, minimum 16 to avoid bugs.

        property bool hug: true // enable hug.
    }

    // Global window state
    property QtObject windows: QtObject {
        property int borderWidth: 2 // Border thickness.
        property color activeColor: ThemeManager.colors.base // Border color.
        property color focusedColor: ThemeManager.colors.sky // Focused border color.
        property string inactiveOpacity: "0.9" // Inactive window opacity.
        property string activeOpacity: "1.0" // Active window opacity.
        property bool enableBlur: true // Enable/Disable Blur.
        property bool enableFading: true // Enable/Disable Fading.

    }

    // Global Configuration
    property QtObject global: QtObject {
        property int corners: 30 // radius, max 40 to prevent bugs.
        property int margins: 10 // margin from the edge, max 30 to prevent bugs.
        property int wallborder: 10 // Desktop borders
        property string language: "english"
    }

    // Theme Manager
    property QtObject theme: QtObject {
        property string colorscheme: "mocha" // latte, frappe, macchiato, mocha
        property string mainfont: "Sofia Pro" // Text font
        property string iconfont: "Material Design Icons Desktop" // Icons font
    }
}