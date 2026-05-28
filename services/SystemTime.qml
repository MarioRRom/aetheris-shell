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
import Quickshell

// Config
import qs.i18n

QtObject {
    id: systemTime
    
    property SystemClock clock: SystemClock {
        precision: SystemClock.Seconds
    }
    
    readonly property string timeFormat: Qt.formatDateTime(clock.date, "h:mm AP")
    readonly property string dayName: {
        if (!clock.date) return LanguageManager.t("weather.loading")
        var days = [
            LanguageManager.t("calendar.sunday"),
            LanguageManager.t("calendar.monday"),
            LanguageManager.t("calendar.tuesday"),
            LanguageManager.t("calendar.wednesday"),
            LanguageManager.t("calendar.thursday"),
            LanguageManager.t("calendar.friday"),
            LanguageManager.t("calendar.saturday")
        ]
        return days[clock.date.getDay()]
    }
}