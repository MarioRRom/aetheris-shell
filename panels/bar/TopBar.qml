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


// IRMINSUL: El eje del mundo.
// La estructura superior que sostiene la red de información. 
// Actúa como la rama principal desde donde cuelgan los frutos 
// del conocimiento (Akasha) y las leyes de la realidad (Khemia).


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import Quickshell
import Quickshell.Io

// Globales
import qs.components
import qs.config
import qs.themes
import qs.modules
import qs.panels.bar.elements

// Menus
import qs.panels.systeminfo
import qs.panels.akasha
import qs.panels.controlcenter
import qs.panels.controlplayer


//  .-------------------------.
//  | .---------------------. |
//  | |Crear Barra Superior | |
//  | `---------------------' |
//  `-------------------------'

Scope {
  id: topBar


  // IPC Handler(para atajos de teclado) //
  signal closeAllWidgets()
  IpcHandler {
    target: "bar"
    function closeAllWidgets() {
      topBar.closeAllWidgets()
    }
  }

  property string panelState: Config.topBar.state // "maximized" o "float"
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
        //  | | Estilo de la Barra  | |
        //  | `---------------------' |
        //  `-------------------------'
      
        // el sombreado y los Hug Corners
        // se encuentran en el Background.qml

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
        //  | |Contenido de la Barra| |
        //  | `---------------------' |
        //  `-------------------------'

        Item {
          id: topBarContent
          anchors.fill: parent
          property int cornerRadius: 0


          // Background de la Barra //
          Rectangle {
            id: barBackground
            anchors.fill: parent
            color: ThemeManager.colors.mantle
            radius: topBarContent.cornerRadius
          }

          // Irminsul Animation //
          AkashaPulse {
            id: irmiPulse
            anchors.fill: parent

          }

          // Maximized State //
          anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: undefined
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
            SysInfo {
              // Mouse Actions //         
              // Loader para Optimización //
              LazyLoader {
                id: sysInfoLoader
                active: false 

                component: SystemInfo {
                  anchor.window: topBarRoot
                  bar: topBarRoot
                  visible: true
                }
              }
            }

            // Workspaces Indicator //
            Workspaces {}

            // Media Player Info //
            PlayerInfo {
              // Mouse Actions //
              // LazyLoader para Optimización
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
          //  | | Elementos Centrales | |
          //  | `---------------------' |
          //  `-------------------------'

          // Center Panel Toggle Button //
          CenterPanel {
            // Mouse Actions //
            // Loader para Optimización //
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
            SysUsage {}

            // System Tray //
            SystemTray {
              anchors.verticalCenter: parent.verticalCenter
              bar: topBarRoot  // Referencia al PanelWindow
            }
            
            // Control Center //
            StatusIndicators {
              // Mouse Actions //
              // Loader para Optimización //
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

            // Windows Stacking //
            WorkLayout {}
          }

          // IPC Handler(para atajos de teclado) //
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