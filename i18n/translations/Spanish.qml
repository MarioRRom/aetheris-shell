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

// Quickshell
import QtQuick

QtObject {

    readonly property var data: ({


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  SystemInfo Panel   | |
        //  | `---------------------' |
        //  `-------------------------'

        "systeminfo.logout": "Cerrar Sesión",
        "systeminfo.shutdown": "Apagar",
        "systeminfo.reboot": "Reiniciar",
        "systeminfo.suspend": "Suspender",
        "systeminfo.cpu": "CPU:",
        "systeminfo.ram": "RAM:",
        "systeminfo.dsk": "DSK:",
        "systeminfo.tmp": "TMP:",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    Profile Card     | |
        //  | `---------------------' |
        //  `-------------------------'

        "profilecard.welcome": "bienvenido a ",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Control Center    | |
        //  | `---------------------' |
        //  `-------------------------'

        "controlcenter.bluetooth": "Bluetooth",
        "controlcenter.network": "Internet",
        "controlcenter.ethernet": "Ethernet ",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    Network Menu     | |
        //  | `---------------------' |
        //  | `---------------------' |
        //  `-------------------------'

        "networkmenu.connect": "Conectar",
        "networkmenu.cancel": "Cancelar",
        "networkmenu.disconnect": "Desconectar",
        "networkmenu.forget": "Olvidar",
        "networkmenu.wifiDisabled": "Wi-Fi Desactivado",
        "networkmenu.noNetworks": "No hay redes disponibles",
        "networkmenu.internet": "Internet",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Bluetooth Menu    | |
        //  | `---------------------' |
        //  `-------------------------'

        "bluetoothmenu.deviceList": "Lista de dispositivos...",
        "bluetoothmenu.bluetooth": "Bluetooth",
        "bluetoothmenu.disabled": "Desactivado",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  Calendar / Akasha  | |
        //  | `---------------------' |
        //  `-------------------------'

        // Months
        "calendar.january": "Enero",
        "calendar.february": "Febrero",
        "calendar.march": "Marzo",
        "calendar.april": "Abril",
        "calendar.may": "Mayo",
        "calendar.june": "Junio",
        "calendar.july": "Julio",
        "calendar.august": "Agosto",
        "calendar.september": "Septiembre",
        "calendar.october": "Octubre",
        "calendar.november": "Noviembre",
        "calendar.december": "Diciembre",

        // Day abbreviations
        "calendar.sun": "Dom",
        "calendar.mon": "Lun",
        "calendar.tue": "Mar",
        "calendar.wed": "Mié",
        "calendar.thu": "Jue",
        "calendar.fri": "Vie",
        "calendar.sat": "Sáb",

        // Full day names
        "calendar.sunday": "Domingo",
        "calendar.monday": "Lunes",
        "calendar.tuesday": "Martes",
        "calendar.wednesday": "Miércoles",
        "calendar.thursday": "Jueves",
        "calendar.friday": "Viernes",
        "calendar.saturday": "Sábado",

        // Akasha labels
        "akasha.dnd": "No Molestar",
        "akasha.clear": "Limpiar",
        "akasha.noNotifications": "Sin Notificaciones",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |   Network Service   | |
        //  | `---------------------' |
        //  `-------------------------'

        "network.ethernet": "Ethernet",
        "network.wifiBlocked": "Wi-Fi bloqueado (hardware)",
        "network.wifiDisabled": "Wi-Fi desactivado",
        "network.disconnected": "Desconectado",
        "network.captivePortal": "Portal cautivo",
        "network.noInternet": "Sin internet",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |      Weather        | |
        //  | `---------------------' |
        //  `-------------------------'

        "weather.na": "N/A",
        "weather.loading": "Cargando...",
        "weather.unknown": "Unknown",
        "weather.apiError": "Error en API",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    MPRIS Service    | |
        //  | `---------------------' |
        //  `-------------------------'

        "mpris.noTitle": "Sin Título",
        "mpris.noArtist": "Sin Artista",
        "mpris.noPlayer": "Sin Reproductor",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |  SystemStatus Serv. | |
        //  | `---------------------' |
        //  `-------------------------'

        "systemstatus.distro": "Linux",
        "systemstatus.uptime.week": "sem",
        "systemstatus.uptime.day": "d",
        "systemstatus.uptime.hour": "h",
        "systemstatus.uptime.minute": "min",


        //  .-------------------------.
        //  | .---------------------. |
        //  | | Notifications Serv. | |
        //  | `---------------------' |
        //  `-------------------------'

        "notifications.system": "Sistema",


        //  .-------------------------.
        //  | .---------------------. |
        //  | |      Activate       | |
        //  | `---------------------' |
        //  `-------------------------'

        "activate.title": "Activar Linux",
        "activate.subtitle": "Ve a Configuración para activar Linux"

    })
}
