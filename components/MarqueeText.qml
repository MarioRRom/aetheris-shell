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

// Auto-scrolling marquee text. Clips and scrolls when text overflows width.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    clip: true

    // Text content to display
    property string text: ""

    // Scroll speed in pixels per second (constant regardless of text length)
    property real scrollSpeed: 30

    // Pause duration at each end in milliseconds
    property int pauseMs: 1000

    // Whether the text is currently scrolling (readonly)
    readonly property bool scrolling: contentText.paintedWidth > root.width

    // Direct access to the internal Text item for advanced use
    readonly property alias textItem: contentText

    // Text appearance aliases
    property alias font: contentText.font
    property alias color: contentText.color
    property alias horizontalAlignment: contentText.horizontalAlignment
    property alias verticalAlignment: contentText.verticalAlignment
    property alias elide: contentText.elide
    property alias textFormat: contentText.textFormat

    Text {
        id: contentText
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
    }

    SequentialAnimation {
        id: anim
        loops: Animation.Infinite
        running: contentText.paintedWidth > root.width

        PauseAnimation { duration: root.pauseMs }
        NumberAnimation {
            target: contentText
            property: "x"
            from: 0
            to: root.width - contentText.paintedWidth
            duration: Math.max(1, (contentText.paintedWidth - root.width) / root.scrollSpeed * 1000)
        }
        PauseAnimation { duration: root.pauseMs }
        NumberAnimation {
            target: contentText
            property: "x"
            from: root.width - contentText.paintedWidth
            to: 0
            duration: Math.max(1, (contentText.paintedWidth - root.width) / root.scrollSpeed * 1000)
        }
    }

    Connections {
        target: contentText
        function onTextChanged() {
            anim.stop()
            contentText.x = 0
            if (contentText.paintedWidth > root.width) anim.start()
        }
    }

    onWidthChanged: {
        if (contentText.text) {
            anim.stop()
            contentText.x = 0
            if (contentText.paintedWidth > root.width) anim.start()
        }
    }
}
