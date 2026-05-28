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

import QtQuick

QtObject {

    readonly property var data: ({


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  SystemInfo Panel   | |
        //  | `---------------------' |
        //  `-------------------------'

        "systeminfo.logout": "Logout",
        "systeminfo.shutdown": "Shutdown",
        "systeminfo.reboot": "Reboot",
        "systeminfo.suspend": "Suspend",
        "systeminfo.cpu": "CPU:",
        "systeminfo.ram": "RAM:",
        "systeminfo.dsk": "DSK:",
        "systeminfo.tmp": "TMP:",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    Profile Card     | |
        //  | `---------------------' |
        //  `-------------------------'

        "profilecard.welcome": "welcome to ",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Control Center    | |
        //  | `---------------------' |
        //  `-------------------------'

        "controlcenter.bluetooth": "Bluetooth",
        "controlcenter.network": "Network",
        "controlcenter.ethernet": "Ethernet ",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    Network Menu     | |
        //  | `---------------------' |
        //  `-------------------------'

        "networkmenu.connect": "Connect",
        "networkmenu.cancel": "Cancel",
        "networkmenu.disconnect": "Disconnect",
        "networkmenu.forget": "Forget",
        "networkmenu.wifiDisabled": "Wi-Fi Disabled",
        "networkmenu.noNetworks": "No networks available",
        "networkmenu.internet": "Internet",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Bluetooth Menu    | |
        //  | `---------------------' |
        //  `-------------------------'

        "bluetoothmenu.deviceList": "Device list...",
        "bluetoothmenu.bluetooth": "Bluetooth",
        "bluetoothmenu.disabled": "Disabled",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  Calendar / Akasha  | |
        //  | `---------------------' |
        //  `-------------------------'

        // Months
        "calendar.january": "January",
        "calendar.february": "February",
        "calendar.march": "March",
        "calendar.april": "April",
        "calendar.may": "May",
        "calendar.june": "June",
        "calendar.july": "July",
        "calendar.august": "August",
        "calendar.september": "September",
        "calendar.october": "October",
        "calendar.november": "November",
        "calendar.december": "December",

        // Day abbreviations
        "calendar.sun": "Sun",
        "calendar.mon": "Mon",
        "calendar.tue": "Tue",
        "calendar.wed": "Wed",
        "calendar.thu": "Thu",
        "calendar.fri": "Fri",
        "calendar.sat": "Sat",

        // Full day names
        "calendar.sunday": "Sunday",
        "calendar.monday": "Monday",
        "calendar.tuesday": "Tuesday",
        "calendar.wednesday": "Wednesday",
        "calendar.thursday": "Thursday",
        "calendar.friday": "Friday",
        "calendar.saturday": "Saturday",

        // Akasha labels
        "akasha.dnd": "Do Not Disturb",
        "akasha.clear": "Clear",
        "akasha.noNotifications": "No Notifications",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Network Service   | |
        //  | `---------------------' |
        //  `-------------------------'

        "network.ethernet": "Ethernet",
        "network.wifiBlocked": "Wi-Fi blocked (hardware)",
        "network.wifiDisabled": "Wi-Fi disabled",
        "network.disconnected": "Disconnected",
        "network.captivePortal": "Captive portal",
        "network.noInternet": "No internet",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |      Weather        | |
        //  | `---------------------' |
        //  `-------------------------'

        "weather.na": "N/A",
        "weather.loading": "Loading...",
        "weather.unknown": "Unknown",
        "weather.apiError": "API Error",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    MPRIS Service    | |
        //  | `---------------------' |
        //  `-------------------------'

        "mpris.noTitle": "No Title",
        "mpris.noArtist": "No Artist",
        "mpris.noPlayer": "No Player",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  SystemStatus Serv. | |
        //  | `---------------------' |
        //  `-------------------------'

        "systemstatus.user": "User",
        "systemstatus.distro": "Linux",


        //  .-------------------------.
        //  | .---------------------. |
        //  | | Notifications Serv. | |
        //  | `---------------------' |
        //  `-------------------------'

        "notifications.system": "System",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |      Activate       | |
        //  | `---------------------' |
        //  `-------------------------'

        "activate.title": "Activate Linux",
        "activate.subtitle": "Go to Settings to activate Linux"

    })
}
