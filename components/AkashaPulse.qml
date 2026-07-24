//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██║  ██║██║   ██║██║╚██╔╝██║
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
    id: pulseRoot
    anchors.fill: parent

    property real targetX: 0
    property int wavesPerSide: 14  // How many waves per side
    property int animDelay: 14
    property var image: "../assets/akasha.svg"
    property real imageOpacity: 0.8
    property real opacityStep: 0.05

    anchors.margins: pulseRoot.height * 0.2
    opacity: 0

    function trigger(gx) {
        targetX = gx
        pulseRoot.opacity = 1

        // Trigger center image
        centerItem.startWave()

        // Trigger left waves
        for (let i = 0; i < leftRepeater.count; i++) {
            let item = leftRepeater.itemAt(i)
            if (item) item.startWave()
        }

        // Trigger right waves
        for (let i = 0; i < rightRepeater.count; i++) {
            let item = rightRepeater.itemAt(i)
            if (item) item.startWave()
        }

        resetAnim.restart()
    }

    // Central image (centered at click point)
    Item {
        id: centerItem
        anchors.fill: parent

        function startWave() {
            centerImg.opacity = 0
            centerAnim.restart()
        }

        Image {
            id: centerImg
            // Image center aligned with targetX
            x: pulseRoot.targetX - (pulseRoot.height / 2)
            y: 0
            width: pulseRoot.height
            height: pulseRoot.height
            source: image
            sourceSize.width: pulseRoot.height
            sourceSize.height: pulseRoot.height
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
                to: imageOpacity
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    // Waves to the left
    Repeater {
        id: leftRepeater
        model: wavesPerSide

        delegate: Item {
            anchors.fill: parent
            required property int index

            function startWave() {
                waveImg.opacity = 0
                waveAnim.restart()
            }

            Image {
                id: waveImg
                // Center of central image - half width - (index+1) * full width
                x: pulseRoot.targetX - (pulseRoot.height / 2) - ((index + 1) * pulseRoot.height)
                y: 0
                width: pulseRoot.height
                height: pulseRoot.height
                source: image
                sourceSize.width: pulseRoot.height
                sourceSize.height: pulseRoot.height
                mipmap: true
                smooth: true
                cache: false
                opacity: 0
            }

            SequentialAnimation {
                id: waveAnim

                PauseAnimation {
                    duration: (index + 1) * pulseRoot.animDelay
                }

                NumberAnimation {
                    target: waveImg
                    property: "opacity"
                    from: 0
                to: Math.max(0, imageOpacity - ((index + 1) * pulseRoot.opacityStep))
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Waves to the right
    Repeater {
        id: rightRepeater
        model: wavesPerSide

        delegate: Item {
            anchors.fill: parent
            required property int index

            function startWave() {
                rightWaveImg.opacity = 0
                rightWaveAnim.restart()
            }

            Image {
                id: rightWaveImg
                // Center of central image + half width + (index) * full width
                x: pulseRoot.targetX + (pulseRoot.height / 2) + (index * pulseRoot.height)
                y: 0
                width: pulseRoot.height
                height: pulseRoot.height
                source: image
                sourceSize.width: pulseRoot.height
                sourceSize.height: pulseRoot.height
                mipmap: true
                smooth: true
                cache: false
                opacity: 0
            }

            SequentialAnimation {
                id: rightWaveAnim

                PauseAnimation {
                    duration: (index + 1) * pulseRoot.animDelay
                }

                NumberAnimation {
                    target: rightWaveImg
                    property: "opacity"
                    from: 0
                to: Math.max(0, imageOpacity - ((index + 1) * pulseRoot.opacityStep))
                    duration: 300
                    easing.type: Easing.OutCubic
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