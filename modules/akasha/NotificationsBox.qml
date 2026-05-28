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
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// Config
import qs.config
import qs.components
import qs.i18n
import qs.services
import qs.themes

Rectangle {
    id: notiRoot

    color: "transparent"

    // Internal calculations.
    property int rootRadius: itemRadius
    property int rootMargin: 10
    property int notifRadius:  rootRadius - rootMargin
    property int internalMargin: 5

    // notifCards Settings
    property int cardSize: 80
    property int cardSpacing: 8
    property int animDuration: Notifications.popupAnimDuration // Sync with the backend


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Box Decorations   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Shadow
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
        spread: 0.0
        cached: true
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: ThemeManager.colors.base
        radius: itemRadius
        clip: true

        // Decoration
        InnerLine {
            anchors.fill: parent
            lineradius: itemRadius
            linewidth: 1
            linecolor: ThemeManager.colors.surface0
        }
    }
    
    // Notification Box
    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: rootMargin
        anchors.leftMargin: rootMargin
        anchors.bottomMargin: rootMargin

        // Notification List
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true


            //  .-------------------------.
            //  | .---------------------. |
            //  | |     Empty State     | |
            //  | `---------------------' |
            //  `-------------------------'

            // Empty Notifications State
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                opacity: Notifications.history.length === 0 ? 1 : 0
                visible: opacity > 0
                Behavior on opacity { NumberAnimation { duration: 300 } }

                Text { 
                    text: "󰂚"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: 100
                    color: ThemeManager.colors.peach
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: LanguageManager.t("akasha.noNotifications")
                    font.pixelSize: 20
                    color: ThemeManager.colors.surface2
                    font.family: ThemeManager.fonts.main
                    Layout.alignment: Qt.AlignHCenter
                }
            }


            //  .-------------------------.
            //  | .---------------------. |
            //  | |  Notification List  | |
            //  | `---------------------' |
            //  `-------------------------'

            // Notification listing.
            Flickable {
                anchors.fill: parent
                contentHeight: notiColumn.implicitHeight
                clip: true
                opacity: Notifications.history.length > 0 ? 1 : 0
                visible: opacity > 0
                Behavior on opacity { NumberAnimation { duration: 300 } }
                
                
                ColumnLayout {
                    id: notiColumn
                    width: parent.width - rootMargin
                    spacing: 0
            
                    // Notification preset.
                    Repeater {
                        id: listRepeater
                        model: Notifications.history
                    
                        delegate: Rectangle {
                            id: notifDelegate
                            Layout.fillWidth: true

                            color: "transparent"
                            clip: true

                            property var notif: modelData
                            property string iconSource: notif ? (notif.image != "" ? notif.image : notif.appIcon) : ""


                            //  .-------------------------.
                            //  | .---------------------. |
                            //  | |     Animations      | |
                            //  | `---------------------' |
                            //  `-------------------------'

                            opacity: notif.shown ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic } }
                            
                            // Entry/exit animation via height + opacity together
                            Layout.preferredHeight: notif.shown ? (cardSize + (internalMargin * 2)) : 0
                            Layout.bottomMargin: notif.shown ? cardSpacing : 0

                            Behavior on Layout.preferredHeight {
                                NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic }
                            }
                            
                            Behavior on Layout.bottomMargin {
                                NumberAnimation { duration: animDuration; easing.type: Easing.OutCubic }
                            }

                            property Timer slideClose: Timer {
                                interval: animDuration
                                onTriggered: notif.close()
                            }

                            Component.onCompleted: {
                                if (!notif.shown) {
                                    notif.shown = true
                                }
                            }


                            //  .-------------------------.
                            //  | .---------------------. |
                            //  | |     Decorations     | |
                            //  | `---------------------' |
                            //  `-------------------------'

                            // Shadow
                            Loader {
                                anchors.fill: parent
                                active: Config.shadows.enabled

                                sourceComponent:RectangularShadow {
                                    anchors.fill: parent
                                    radius: notifRadius
                                    color: Config.shadows.color

                                    blur: 3
                                    offset: Qt.vector2d(1, 1)
                                    spread: 1.0
                                    cached: true
                                }
                            }

                            // Background
                            Rectangle {
                                anchors.fill: parent
                                radius: notifRadius
                                color: ThemeManager.colors.surface0
                                clip: true

                                // Decoration
                                InnerLine {
                                    anchors.fill: parent
                                    lineradius: notifRadius
                                    linewidth: 1
                                    linecolor: ThemeManager.colors.surface1
                                }
                            }


                            //  .-------------------------.
                            //  | .---------------------. |
                            //  | |   Notif Structure   | |
                            //  | `---------------------' |
                            //  `-------------------------'
                            
                            // Mouse Area to trigger the notification.
                            MouseArea {
                                id: hoverArea
                                visible: notif.actions > []
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: notif.activate()
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: internalMargin

                                // Image or bell
                                Text {
                                    visible: iconSource == ""
                                    text: "󰂚"
                                    color: ThemeManager.colors.peach
                                    font.family: ThemeManager.fonts.icons
                                    font.pixelSize: (parent.height -10 )
                                }
                                MaskedImage {
                                    visible: iconSource != ""
                                    Layout.preferredHeight: parent.height - 10
                                    Layout.preferredWidth: height

                                    imageRadius: (rootRadius - 5)
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
                                    radius: notifRadius - internalMargin
                                    Layout.alignment: Qt.AlignTop

                                    Text {
                                        anchors.centerIn: parent
                                        text: ""
                                        color: ThemeManager.colors.text
                                        font.family: ThemeManager.fonts.icons
                                        font.pixelSize: 16
                                    }

                                    MouseArea {
                                        id: closeArea
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onClicked: {
                                            notif.shown = false
                                            slideClose.start()
                                        }
                                    }

                                    states: [
                                        State {
                                            name: "hover"
                                            when: closeArea.containsMouse && !closeArea.pressed
                                            PropertyChanges {
                                                target: closeBtn
                                                color: ThemeManager.colors.surface1
                                            }
                                        },
                                        State {
                                            name: "pressed"
                                            when: closeArea.pressed
                                            PropertyChanges {
                                                target: closeBtn
                                                color: ThemeManager.colors.red
                                            }
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
}