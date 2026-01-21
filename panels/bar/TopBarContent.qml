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


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets

// Globales
import qs.themes
import qs.modules
import qs.modules.bspwm
import qs.modules.hyprland

// Menus
import qs.panels.systeminfo // System Info Panel.
import qs.panels.akasha // Notification/Calendar/Weather Panel.
import qs.panels.controlcenter // Control Center Panel.
import qs.panels.controlplayer // Control Player Panel.





Item {
    id: root
    property int cornerRadius: 0
    property var barWindow

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: ThemeManager.colors.mantle
        radius: root.cornerRadius
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Elementos Izquierda | |
    //  | `---------------------' |
    //  `-------------------------'

    Row {
        height: parent.height
        anchors {
        left: parent.left
        leftMargin: 10
        }

        spacing: 5
    

        // Euthymia (System Info) //
        WrapperMouseArea{
            cursorShape: Qt.PointingHandCursor
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                sysInfoLoader.active = !sysInfoLoader.active
                //Quickshell.execDetached(["Eww", "open", "--toggle", "systeminfo", "--screen", modelData.name])
            }

            Text {
                text: "󰣇"
                color: ThemeManager.colors.blue
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 24
            }
            
            // Loader para Optimización
            LazyLoader {
                id: sysInfoLoader
                active: false 

                component: SystemInfo {
                    id: sysInfo
                    anchor.window: barWindow
                    bar: barWindow
                    visible: true
                }
            }
        }


        // Workspaces Indicators //
        WrapperRectangle {
        color: ThemeManager.colors.base
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - 12
        radius: 10

            Row {
                leftPadding: 10
                rightPadding: 10
            
                BspWorkspaces {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: true
                    monitorName: modelData.name
                }

                HyprWorkspaces {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    monitorName: modelData.name
                }
            }
        }
        

        // Media Player Info //
        Item {
            id: player
            visible: Mpris.status
            anchors.verticalCenter: parent.verticalCenter
            width: 190
            height: parent.height
            
            // Mouse Actions //
            MouseArea {
                id: playerArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        Mpris.playpause()
                    } else if (mouse.button === Qt.RightButton) {
                        let gx = player.mapToItem(barWindow.contentItem, 0, 0).x

                        conPlayerLoader.active = !conPlayerLoader.active

                        if (conPlayerLoader.active && conPlayerLoader.item) {
                            conPlayerLoader.item.globalPos = gx
                        }
                    }
                }
            }

            // LazyLoader para Optimización
            LazyLoader {
                id: conPlayerLoader
                active: false 

                component: ControlPlayer {
                    id: controlWidget
                    anchor.window: barWindow
                    bar: barWindow
                    visible: true
                }
            }

            // Media Player Status //
            Row {
                anchors.fill: parent
                spacing: 5

                // Media Player Status Icon //
                Text {
                    id: statusIcon
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰎆"
                    color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: 16

                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                // Music Title //
                Rectangle {
                    id: playerTitleArea
                    anchors.verticalCenter: parent.verticalCenter
                    

                    width: parent.width - statusIcon.width - parent.spacing
                    height: parent.height

                    color: "transparent"
                    clip: true
                    
                    Text {
                        id: titleText
                        anchors.verticalCenter: parent.verticalCenter
                        text: Mpris.title
                        color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
                        font.family: ThemeManager.fonts.main
                        font.pixelSize: 14

                        Behavior on color { ColorAnimation { duration: 200 } }
                        x: 0
                    }

                    SequentialAnimation {
                        id: marqueeAnimation
                        loops: Animation.Infinite
                        running: titleText.paintedWidth > 160
                        PauseAnimation {
                            duration: 1000
                        }
                        NumberAnimation {
                            target: titleText
                            property: "x"
                            from: 0
                            to: 160 - titleText.paintedWidth
                            duration: 8000
                        }
                        PauseAnimation {
                            duration: 1000
                        }
                        NumberAnimation {
                            target: titleText
                            property: "x"
                            from: 160 - titleText.paintedWidth
                            to: 0
                            duration: 8000
                        }
                    }

                    Connections {
                        target: titleText
                        function onTextChanged() {
                        marqueeAnimation.stop();
                        titleText.x = 0;
                        if (titleText.paintedWidth > 160) {
                            marqueeAnimation.start();
                        }
                        }
                    }
                }
            }
        }
    }

    //  .-------------------------.
    //  | .---------------------. |
    //  | | Elementos Centrales | |
    //  | `---------------------' |
    //  `-------------------------'


    // Center Panel Toggle Button //
    WrapperMouseArea {
        id: centerPanelArea
        height: parent.height -12
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
        akashaPanel.visible = !akashaPanel.visible
        //Quickshell.execDetached(["Eww", "open", "--toggle", "centerpanel", "--screen", modelData.name])
        }

        Akasha {
            id: akashaPanel
            anchor.window: barWindow
            bar: barWindow
            visible: false
        }

        WrapperRectangle {
        id: centerPanelButton
        height: parent.height
        color: ThemeManager.colors.mantle
        radius: 24

        states: [
            State {
            name: "hovered"
            when: centerPanelArea.containsMouse
            PropertyChanges {
                target: centerPanelButton
                color: ThemeManager.colors.base
            }
            },
            State {
            name: "pressed"
            when: centerPanelArea.pressed
            PropertyChanges {
                target: centerPanelButton
                color: ThemeManager.colors.surface0
            }
            }
        ]

        Behavior on color {
            ColorAnimation {
            duration: 150
            }
        }

        Row {
            spacing: 5
            leftPadding: 10
            rightPadding: 10

            // System Time //
            Text {
            text: SystemTime.timeFormat
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 17
            }


            // Weather Info //
            Text {
            text: Weather.icon
            color: Weather.color
            font.family: ThemeManager.fonts.icons
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 16
            }

            Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Weather.temperature
            color: Weather.color
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14
            }
        }
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Elementos Derecha  | |
    //  | `---------------------' |
    //  `-------------------------'

    Row {
        height: parent.height
        anchors {
        right: parent.right
        rightMargin: 10
        }

        spacing: 5

        // System Usage //

        Text {
            text: ""
            color: ThemeManager.colors.red
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: SystemStatus.cpuUsagePercent + "%"
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: ""
            color: ThemeManager.colors.yellow
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: SystemStatus.ramUsagePercent + "%"
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

    
        // System Tray //
        SystemTray {
            anchors.verticalCenter: parent.verticalCenter
            bar: barWindow  // Referencia al PanelWindow
        }
        
        // Control Center //
        WrapperMouseArea{
        id: controlCenterArea
        height: parent.height -12
        anchors.verticalCenter: parent.verticalCenter
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            controlCenterPanel.visible = !controlCenterPanel.visible
            //Quickshell.execDetached(["Eww", "open", "--toggle", "controlcenter", "--screen", modelData.name])
        }

        ControlCenter {
            id: controlCenterPanel
            anchor.window: barWindow
            bar: barWindow
            visible: false
        }
        
        WrapperRectangle {
            id: controlCenterButton
            height: parent.height
            
            color: ThemeManager.colors.base
            radius: 24

            states: [
            State {
                name: "hovered"
                when: controlCenterArea.containsMouse
                PropertyChanges {
                target: controlCenterButton
                color: ThemeManager.colors.surface0
                }
            },
            State {
                name: "pressed"
                when: controlCenterArea.pressed
                PropertyChanges {
                target: controlCenterButton
                color: ThemeManager.colors.surface1
                }
            }
            ]

            Behavior on color {
            ColorAnimation {
                duration: 150
            }
            }

            Row {
            spacing: 3
            leftPadding: 10
            rightPadding: 10
            
            Text {
                text: "󰈀"
                color: ThemeManager.colors.mauve
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: Pipewire.icon
                color: Pipewire.muted? ThemeManager.colors.red : ThemeManager.colors.green
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "󰁹"
                color: ThemeManager.colors.peach
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            }
        }
        }

        // Windows Stacking //
        BspLayout {
            visible: true
            anchors.verticalCenter: parent.verticalCenter
        }

        HyprLayout {
            visible: false
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}