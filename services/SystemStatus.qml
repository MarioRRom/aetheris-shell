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
import Quickshell.Io

// Config
import qs.i18n

Item {
    id: root
    

    //  .-------------------------.
    //  | .---------------------. |
    //  | | Static Information  | |
    //  | `---------------------' |
    //  `-------------------------'
    
    property string username: LanguageManager.t("systemstatus.user")
    property string distro: LanguageManager.t("systemstatus.distro")
    property string desktop: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()

    Process {
        id: procUser
        command: ["whoami"]
        running: false
        stdout: SplitParser {
            onRead: data => root.username = data.trim()
        }
    }

    Process {
        id: procDistro
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

    // Uptime
    Process {
        id: procUptime
        command: ["uptime", "-p"]
        running: false
        stdout: SplitParser {
            onRead: data => root.uptime = data.trim().replace("up ", "")
        }
    }

    // Disk (Root)
    Process {
        id: procDisk
        command: ["bash", "-c", "df / --output=pcent | tail -1 | tr -d '% \n'"]
        running: false
        stdout: SplitParser {
            onRead: data => root.diskUsage = parseInt(data)
        }
    }

    // Temperature (Finds the max among available sensors)
    Process {
        id: procTemp
        // Reuses your script's logic: searches common paths, sorts descending, takes the highest.
        command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone*/temp /sys/class/hwmon/hwmon*/temp*_input 2>/dev/null | sort -nr | head -n1"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const val = parseInt(data)
                // Verify it's a valid number before assigning
                if (!isNaN(val)) root.temperature = Math.round(val / 1000)
            }
        }
    }

    // Timer for updating slow processes (1 minute)
    Timer {
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
    Timer {
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

    Process {
        id: procRam
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
    
    Process {
        id: procCpu
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

    Timer {
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
        procUser.running = true
        procDistro.running = true
    }
}