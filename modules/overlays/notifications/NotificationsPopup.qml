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
import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

// Config
import qs.config
import qs.components
import qs.themes
import qs.services


LazyLoader {
    active: Notifications.popups.length > 0 && isActivated
    property bool isActivated: false
    property QtObject backgroundAnchor: null


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Load Global Config  | |
    //  | `---------------------' |
    //  `-------------------------'

    // global Status
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins + 10
    property int cornerRadius: globalCorners - globalMargin

    // bar maximized case
    property int wallborder: Config.global.wallborder
    property string topBarState: Config.topBar.state
    property int totalMargin: topBarState === "maximized" ? wallborder + globalMargin : globalMargin

    // notifications panel settings
    property int outMargin: 5 // External margin for the Shadow.
    property int windowMargin: 10 // Internal margin.
    property int itemRadius: cornerRadius - windowMargin

    // Notification card settings
    property int cardSize: 100
    property int cardCount: 3
    property int cardSpacing: 5
    property int animDuration: Notifications.popupAnimDuration // Sync with the backend


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Notification Popups | |
    //  | `---------------------' |
    //  `-------------------------'

    component: PopupWindow {
        id: notificationsRoot
        visible: true

        // Pin to Background
        // Prevents flickering as popup/transient window type
        anchor.window: backgroundAnchor
        anchor.rect.x: (backgroundAnchor?.width ?? 0) - implicitWidth - (totalMargin - outMargin)
        anchor.rect.y: (backgroundAnchor?.height ?? 0) - implicitHeight - (totalMargin - outMargin)

        // Dynamic size
        // Prevents black square when compositor disables transparency.
        implicitWidth: Notifications.popups.length > 0 ? 400 : 0
        implicitHeight: Notifications.popups.length > 0 ? ((cardSize + cardSpacing) * cardCount) + (outMargin * 2) : 0

        color: "transparent"

        // Listen for expiration signal to animate exit
        Connections {
            target: Notifications
            function onNotificationExpiring(notif) {
                for (let i = 0; i < listRepeater.count; i++) {
                    const item = listRepeater.itemAt(i)
                    if (item?.notif === notif) { item.animateOut(); break }
                }
            }
        }

        // Main Column, to chain multiple Notifications.
        ColumnLayout {
            id: notificationsLayout
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: outMargin
            spacing: 0


            Repeater {
                id: listRepeater
                model: Notifications.popups.slice(0, cardCount + 1).reverse()

                // Main Container.
                delegate: Rectangle {
                    id: notificationsContainer

                    property var notif: modelData
                    property string iconSource: notif ? (notif.image !== "" ? notif.image : notif.appIcon) : ""


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |     Animations      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    // Stack opacity
                    property real stackOpacity: {
                        if (!notif.shownPopup) return 0
                        const fadeIndex = listRepeater.count - 1 - index
                        if (fadeIndex >= cardCount) return 1.0 - ((cardCount - 1) * 0.25)
                        if (hoverArea.containsMouse) return 1.0
                        if (closeArea.containsMouse) return 1.0
                        return 1.0 - (fadeIndex * 0.25)
                    }

                    opacity: stackOpacity
                    Behavior on stackOpacity { NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic } }

                    // Entry/exit animation via height + opacity together
                    Layout.preferredHeight: notif.shownPopup ? cardSize : 0
                    Layout.bottomMargin: notif.shownPopup ? cardSpacing : 0

                    Behavior on Layout.preferredHeight {
                        NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic }
                    }

                    Behavior on Layout.bottomMargin {
                        NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic }
                    }

                    Component.onCompleted: Qt.callLater(() => {
                        notif.shownPopup = true
                        notificationsContainer.stackOpacity = Qt.binding(() => {
                            if (!notif.shownPopup) return 0
                            if (hoverArea.containsMouse) return 1.0
                            if (closeArea.containsMouse) return 1.0
                            const fadeIndex = listRepeater.count - 1 - index
                            if (fadeIndex >= cardCount) return 0
                            return 1.0 - (fadeIndex * 0.25)
                        })

                        // collapse height of the last one when cardCount is exceeded
                        const fadeIndex = listRepeater.count - 1 - index
                        if (fadeIndex >= cardCount) {
                            notif.shownPopup = false
                        }
                    })

                    function animateOut() {
                        notif.shownPopup = false
                    }


                    // Mouse Actions
                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: notif.actions > [] ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: notif.activate()
                    }

                    Layout.fillWidth: true
                    color: "transparent"


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |    Decorations      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    // Shadow
                    Loader {
                        anchors.fill: parent
                        active: Config.shadows.enabled
                        sourceComponent: RectangularShadow {
                            anchors.fill: parent
                            radius: cornerRadius
                            color: Config.shadows.color
                            opacity: notificationsContainer.opacity

                            blur: 3
                            offset: Qt.vector2d(2, 2)
                            spread: 1.0
                            cached: true
                        }
                    }

                    // Background
                    Rectangle {
                        anchors.fill: parent
                        radius: cornerRadius
                        color: ThemeManager.colors.mantle
                        clip: true

                        // Decoration
                        InnerLine {
                            anchors.fill: parent
                            lineradius: cornerRadius
                            linewidth: 2
                            linecolor: ThemeManager.colors.surface0
                        }

                        // Timeout ProgressBar
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: cornerRadius
                            anchors.rightMargin: cornerRadius
                            height: 3
                            radius: cornerRadius
                            color: "transparent"

                            // Timeout bar
                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width * notif.progress
                                radius: cornerRadius
                                color: Notifications.expireLock ? ThemeManager.colors.yellow : ThemeManager.colors.red
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }


                        //  .-------------------------.
                        //  | .---------------------. |
                        //  | |   Notif Structure   | |
                        //  | `---------------------' |
                        //  `-------------------------'

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: windowMargin
                            spacing: windowMargin


                            // Image or bell
                            SvgIcon {
                                visible: iconSource == ""
                                icon: "communicate/notifications"
                                size: parent.height - 10
                                color: ThemeManager.colors.peach
                            }

                            MaskedImage {
                                visible: iconSource !== ""
                                Layout.preferredHeight: parent.height - 10
                                Layout.preferredWidth: height

                                imageRadius: itemRadius
                                imageSource: iconSource
                            }

                            // Text strings
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                clip: true
                                spacing: 0

                                // AppName
                                Text {
                                    text: notif.appName
                                    color: ThemeManager.colors.green
                                    font.family: ThemeManager.fonts.main
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    maximumLineCount: 1
                                }

                                // Title
                                Text {
                                    text: notif.summary
                                    color: ThemeManager.colors.text
                                    font.family: ThemeManager.fonts.main
                                    font.pixelSize: 18
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    maximumLineCount: 1
                                }

                                // Content
                                Text {
                                    text: notif.body
                                    color: ThemeManager.colors.text
                                    font.family: ThemeManager.fonts.main
                                    font.pixelSize: 14
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    maximumLineCount: 2
                                }
                            }

                            // Close button.
                            Rectangle {
                                id: closeBtn
                                width: 23
                                height: width
                                color: ThemeManager.colors.surface0
                                radius: 100
                                Layout.alignment: Qt.AlignTop

                                SvgIcon {
                                    anchors.centerIn: parent
                                    icon: "general/close-small"
                                    size: parent.width + 8
                                    color: ThemeManager.colors.text
                                }

                                MouseArea {
                                    id: closeArea
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: {
                                        notif.closeAfterExpire = true
                                        notif.expire()
                                    }
                                }

                                states: [
                                    State {
                                        name: "hover"
                                        when: closeArea.containsMouse && !closeArea.pressed
                                        PropertyChanges { target: closeBtn; color: ThemeManager.colors.surface1 }
                                    },
                                    State {
                                        name: "pressed"
                                        when: closeArea.pressed
                                        PropertyChanges { target: closeBtn; color: ThemeManager.colors.red }
                                    }
                                ]

                                transitions: Transition {
                                    ColorAnimation { duration: 250 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}