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
import qs.themes

QtObject {

    // public API
    property ShadowsConfig shadows: ShadowsConfig {}
    property TopBarConfig topBar: TopBarConfig {}
    property WindowsConfig windows: WindowsConfig {}
    property GlobalConfig global: GlobalConfig {}
    property ThemeConfig theme: ThemeConfig {}

    // Global Shadows configuration.
    component ShadowsConfig: QtObject {
        property bool enabled: true // Enable shadows.
        property var color: "#80000000" // Shadow color.
    }

    // Global top bar state
    component TopBarConfig: QtObject {
        property string state: "maximized" // float or maximized.
        property int height: 36 // Bar size, minimum 16 to avoid bugs.

        property bool hug: true // enable hug.
    }

    // Global window state
    component WindowsConfig: QtObject {
        property int borderWidth: 2 // Border thickness.
        property color unfocusedBorderColor: ThemeManager.colors.base // Border of unfocused windows.
        property color focusedBorderColor: ThemeManager.colors.sky // Border of focused windows.
        property string inactiveOpacity: "0.9" // Inactive window opacity.
        property string activeOpacity: "1.0" // Active window opacity.
        property bool enableBlur: true // Enable/Disable Blur.
        property bool enableFading: true // Enable/Disable Fading.

    }

    // Global Configuration
    component GlobalConfig: QtObject {
        property int corners: 30 // radius, max 40 to prevent bugs.
        property int margins: 10 // margin from the edge, max 30 to prevent bugs.
        property int wallborder: 10 // Desktop borders
        property string language: "english"
    }

    // Theme Manager
    component ThemeConfig: QtObject {
        property string colorscheme: "mocha" // latte, frappe, macchiato, mocha
        property string mainfont: "Sofia Pro" // Text font
    }
}