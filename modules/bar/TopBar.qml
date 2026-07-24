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

// IRMINSUL: The axis of the world.
// The upper structure that holds the information network.
// Acts as the main branch from which the fruits
// of knowledge Akasha and the laws of reality Khemia hang.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

// Config
import qs.components
import qs.config
import qs.themes
import qs.services

// Modules
import qs.modules.bar.elements
import qs.modules.systeminfo
import qs.modules.akasha
import qs.modules.controlcenter
import qs.modules.controlplayer


//  .-------------------------.
//  | .---------------------. |
//  | |   Create Top Bar    | |
//  | `---------------------' |
//  `-------------------------'

Scope {
  id: topBar


  // IPC Handler(for keyboard shortcuts)
  signal closeAllWidgets()
  IpcHandler {
    target: "bar"
    function closeAllWidgets() {
      topBar.closeAllWidgets()
    }
  }

  property string panelState: Config.topBar.state // "maximized" or "float"
  property bool isActivated: false

  Variants {
    model: Quickshell.screens

    LazyLoader {
      id: topBarLoader
      active: isActivated

      required property var modelData


      component: PanelWindow {
        id: topBarRoot
        screen: topBarLoader.modelData


        //  .-------------------------.
        //  | .---------------------. |
        //  | |      Bar Style      | |
        //  | `---------------------' |
        //  `-------------------------'

        // the shadow and Hug Corners
        // are in Background.qml

        anchors {
          top: true
          left: true
          right: true
        }

        implicitHeight: Config.topBar.height
        aboveWindows: false

        color: "transparent"


        //  .-------------------------.
        //  | .---------------------. |
        //  | |     Bar Content     | |
        //  | `---------------------' |
        //  `-------------------------'

        Item {
          id: topBarContent
          anchors.fill: parent
          property int cornerRadius: 0


          // Background
          Rectangle {
            id: barBackground
            anchors.fill: parent
            color: ThemeManager.colors.mantle
            radius: topBarContent.cornerRadius
          }

          // Akasha Animation
          AkashaPulse {
            id: irmiPulse
            anchors.fill: parent

          }

          // Maximized State
          anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: undefined
          }


          //  .-------------------------.
          //  | .---------------------. |
          //  | |    Left Elements    | |
          //  | `---------------------' |
          //  `-------------------------'

          Row {
            height: parent.height
            anchors {
              left: parent.left
              leftMargin: 10
            }

            spacing: 5

            // System Info
            SysInfo {
              // LazyLoader for Optimization
              LazyLoader {
                id: sysInfoLoader
                active: false

                component: SystemInfo {
                  anchor.window: topBarRoot
                  bar: topBarRoot
                  visible: true
                  closeWidgets: function() { topBar.closeAllWidgets() }
                }
              }
            }

            // Workspaces Indicator
            Workspaces {
              monitorName: topBarLoader.modelData.name
            }

            // Media Player Info
            PlayerInfo {
              // LazyLoader for Optimization
              LazyLoader {
                id: conPlayerLoader
                active: false

                component: ControlPlayer {
                  anchor.window: topBarRoot
                  bar: topBarRoot
                  visible: true
                }
              }
            }
          }

          //  .-------------------------.
          //  | .---------------------. |
          //  | |   Center Elements   | |
          //  | `---------------------' |
          //  `-------------------------'

          // Clock and weather
          CenterPanel {
            // Loader for Optimization
            LazyLoader {
              id: akashaLoader
              active: false

              Akasha {
                anchor.window: topBarRoot
                bar: topBarRoot
                visible: true
              }
            }
          }


          //  .-------------------------.
          //  | .---------------------. |
          //  | |   Right Elements    | |
          //  | `---------------------' |
          //  `-------------------------'

          Row {
            height: parent.height
            anchors {
              right: parent.right
              rightMargin: 10
            }

            spacing: 5

            // System Usage
            SysUsage {}

            // System Tray
            SystemTray {
              anchors.verticalCenter: parent.verticalCenter
              bar: topBarRoot  // PanelWindow reference
            }

            // Control Center
            StatusIndicators {
              // LazyLoader for Optimization
              LazyLoader {
                id: controlCenterLoader
                active: false

                component:ControlCenter {
                  anchor.window: topBarRoot
                  bar: topBarRoot
                  visible: true
                }
              }
            }

            // Windows Stacking
            WorkLayout {}
          }

          // IPC Handler(for keyboard shortcuts)
          Connections {
            target: topBar

            function onCloseAllWidgets() {
              sysInfoLoader.active = false
              conPlayerLoader.active = false
              akashaLoader.active = false
              controlCenterLoader.active = false
            }
          }

          // Float State
          states: State {
            name: "float"
            when: panelState === "float"
            PropertyChanges {
              target: topBarContent
              cornerRadius: Config.global.corners
              anchors {
                topMargin: Config.global.margins
                leftMargin: Math.round(modelData.width * 0.02)
                rightMargin: Math.round(modelData.width * 0.02)
              }
            }
            PropertyChanges {
              target: topBarRoot
              implicitHeight: Config.topBar.height + Config.global.margins
            }
          }
        }
      }
    }
  }
}