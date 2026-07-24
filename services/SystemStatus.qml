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
import Quickshell
import Quickshell.Io

// Config
import qs.i18n

QtObject {
    id: root


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Static Information  | |
    //  | `---------------------' |
    //  `-------------------------'

    property string username: Quickshell.env("USER") || "user"
    property string distro: LanguageManager.t("systemstatus.distro")
    property string desktop: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()

    property Process procDistro: Process {
        command: ["bash", "-c", "grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '\"'"]
        running: false
        stdout: SplitParser {
            onRead: data => root.distro = data.trim()
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Dynamic Information | |
    //  | `---------------------' |
    //  `-------------------------'

    property string uptime: LanguageManager.t("weather.loading")
    property int diskUsage: 0
    property int temperature: 0

    // Uptime (from /proc/uptime, top 1-2 units with i18n)
    property Process procUptime: Process {
        command: ["cat", "/proc/uptime"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const totalSec = parseFloat(data.trim().split(" ")[0])
                if (isNaN(totalSec)) return

                const weeks = Math.floor(totalSec / 604800)
                const days = Math.floor((totalSec % 604800) / 86400)
                const hours = Math.floor((totalSec % 86400) / 3600)
                const minutes = Math.floor((totalSec % 3600) / 60)

                const parts = []
                if (weeks > 0) parts.push(weeks + LanguageManager.t("systemstatus.uptime.week"))
                if (days > 0) parts.push(days + LanguageManager.t("systemstatus.uptime.day"))
                if (hours > 0) parts.push(hours + LanguageManager.t("systemstatus.uptime.hour"))
                if (minutes > 0) parts.push(minutes + LanguageManager.t("systemstatus.uptime.minute"))

                root.uptime = parts.slice(0, 2).join(", ")
            }
        }
    }

    // Disk (Root)
    property Process procDisk: Process {
        command: ["bash", "-c", "df / --output=pcent | tail -1 | tr -d '% \n'"]
        running: false
        stdout: SplitParser {
            onRead: data => root.diskUsage = parseInt(data)
        }
    }

    // Temperature (Finds the max among available sensors)
    property Process procTemp: Process {
        command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone*/temp /sys/class/hwmon/hwmon*/temp*_input 2>/dev/null | sort -nr | head -n1"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const val = parseInt(data)
                if (!isNaN(val)) root.temperature = Math.round(val / 1000)
            }
        }
    }

    // Timer for updating slow processes (1 minute)
    property Timer updateTimer: Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            procUptime.running = true
            procDisk.running = true
        }
    }

    // Temperature timer (2 seconds)
    property Timer temperatureTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: procTemp.running = true
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |Real-Time Information| |
    //  | `---------------------' |
    //  `-------------------------'

    // Helper for byte formatting (e.g.: 16.0 GB)
    function formatBytes(bytes) {
        const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
        if (bytes === 0) return '0 B'
        const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
        return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i]
    }

    // RAM
    property string ramText: "..."
    property int ramUsagePercent: 0

    property Process procRam: Process {
        command: ["bash", "-c", "free -b | awk '/^Mem:/ {print $2, $3}'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ")
                if (parts.length === 2) {
                    const total = parseInt(parts[0])
                    const used = parseInt(parts[1])
                    root.ramUsagePercent = total > 0 ? Math.round((used / total) * 100) : 0
                    root.ramText = root.formatBytes(used) + " / " + root.formatBytes(total)
                }
            }
        }
    }

    // CPU
    property int cpuUsagePercent: 0
    property var _prevCpu: ({total: 0, idle: 0})

    property Process procCpu: Process {
        command: ["cat", "/proc/stat"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("cpu ")) {
                    const parts = data.replace(/\s+/g, " ").trim().split(" ")
                    if (parts.length >= 5) {
                        let idle = parseInt(parts[4])
                        let total = 0
                        for (let i = 1; i < parts.length; i++) total += parseInt(parts[i])

                        const diffTotal = total - root._prevCpu.total
                        const diffIdle = idle - root._prevCpu.idle

                        if (diffTotal > 0) root.cpuUsagePercent = Math.round(((diffTotal - diffIdle) / diffTotal) * 100)

                        root._prevCpu = {total: total, idle: idle}
                    }
                }
            }
        }
    }

    property Timer statsTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            procRam.running = true
            procCpu.running = true
        }
    }

    Component.onCompleted: {
        procDistro.running = true
    }
}