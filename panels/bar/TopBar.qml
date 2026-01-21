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

import QtQuick
import Quickshell
import qs.config
import qs.themes
import qs.modules


//  .-------------------------.
//  | .---------------------. |
//  | |Crear Barra Superior | |
//  | `---------------------' |
//  `-------------------------'

Scope {
  id: topBar

  property string panelState: Config.topBar.state // "maximized" o "float"

  Variants {
    model: Quickshell.screens

    LazyLoader {
      id: topBarLoader
      active: true
      
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

        TopBarContent {
          id: topBarContent
          anchors.fill: parent
          barWindow: topBarRoot

          // Maximized State
          cornerRadius: 0
          anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: undefined
          }

          // Float State
          states: State {
            name: "float"
            when: panelState === "float"
            PropertyChanges {
              target: topBarContent
              cornerRadius: Config.topBar.corners
              anchors {
                topMargin: Config.topBar.margin
                leftMargin: Math.round(modelData.width * 0.02)
                rightMargin: Math.round(modelData.width * 0.02)
              }
            }
            PropertyChanges {
              target: topBarRoot
              implicitHeight: Config.topBar.height + Config.topBar.margin
            }
          }
        }
      }
    }
  }
}