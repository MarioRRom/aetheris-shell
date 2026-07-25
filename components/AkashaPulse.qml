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

// A animation for the bar based on Akasha logo.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: pulse
    anchors.fill: parent

    property real targetX: 0
    property int wavesPerSide: 14  // How many waves per side
    property int animDelay: 14
    property var image: "../assets/akasha.svg"
    property real imageOpacity: 0.8
    property real opacityStep: 0.05
    property int waveVersion: 0

    anchors.margins: pulse.height * 0.2
    opacity: 0

    function trigger(gx) {
        targetX = gx
        pulse.opacity = 1
        waveVersion++
        resetAnim.restart()
    }

    // Central image (centered at click point)
    Item {
        id: centerItem
        anchors.fill: parent

        Image {
            id: centerImg
            x: pulse.targetX - (pulse.height / 2)
            y: 0
            width: pulse.height
            height: pulse.height
            source: pulse.image
            sourceSize.width: pulse.height
            sourceSize.height: pulse.height
            mipmap: true
            smooth: true
            cache: false
            opacity: 0
        }

        SequentialAnimation {
            id: centerAnim

            NumberAnimation {
                target: centerImg
                property: "opacity"
                from: 0
                to: pulse.imageOpacity
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Connections {
            target: pulse
            function onWaveVersionChanged() {
                centerImg.opacity = 0
                centerAnim.restart()
            }
        }
    }

    // Waves to the left
    Repeater {
        id: leftRepeater
        model: pulse.wavesPerSide

        delegate: Item {
            id: leftDelegate
            anchors.fill: parent
            required property int index

            Image {
                id: leftWaveImg
                x: pulse.targetX - (pulse.height / 2) - ((leftDelegate.index + 1) * pulse.height)
                y: 0
                width: pulse.height
                height: pulse.height
                source: pulse.image
                sourceSize.width: pulse.height
                sourceSize.height: pulse.height
                mipmap: true
                smooth: true
                cache: false
                opacity: 0
            }

            SequentialAnimation {
                id: leftWaveAnim

                PauseAnimation {
                    duration: (leftDelegate.index + 1) * pulse.animDelay
                }

                NumberAnimation {
                    target: leftWaveImg
                    property: "opacity"
                    from: 0
                    to: Math.max(0, pulse.imageOpacity - ((leftDelegate.index + 1) * pulse.opacityStep))
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            Connections {
                target: pulse
                function onWaveVersionChanged() {
                    leftWaveImg.opacity = 0
                    leftWaveAnim.restart()
                }
            }
        }
    }

    // Waves to the right
    Repeater {
        id: rightRepeater
        model: pulse.wavesPerSide

        delegate: Item {
            id: rightDelegate
            anchors.fill: parent
            required property int index

            Image {
                id: rightWaveImg
                x: pulse.targetX + (pulse.height / 2) + (rightDelegate.index * pulse.height)
                y: 0
                width: pulse.height
                height: pulse.height
                source: pulse.image
                sourceSize.width: pulse.height
                sourceSize.height: pulse.height
                mipmap: true
                smooth: true
                cache: false
                opacity: 0
            }

            SequentialAnimation {
                id: rightWaveAnim

                PauseAnimation {
                    duration: (rightDelegate.index + 1) * pulse.animDelay
                }

                NumberAnimation {
                    target: rightWaveImg
                    property: "opacity"
                    from: 0
                    to: Math.max(0, pulse.imageOpacity - ((rightDelegate.index + 1) * pulse.opacityStep))
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            Connections {
                target: pulse
                function onWaveVersionChanged() {
                    rightWaveImg.opacity = 0
                    rightWaveAnim.restart()
                }
            }
        }
    }

    SequentialAnimation on opacity {
        id: resetAnim
        running: false
        PauseAnimation { duration: 600 }
        NumberAnimation { to: 0; duration: 400 }
    }
}