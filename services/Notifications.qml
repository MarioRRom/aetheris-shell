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
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// Config
import qs.i18n

QtObject {
    id: root


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Config & State    | |
    //  | `---------------------' |
    //  `-------------------------'

    property bool dnd: false // Do Not Disturb

    // Main notification list
    // each entry is a wrapper object
    property list<QtObject> list: []

    // Useful derivatives
    readonly property list<QtObject> popups: list.filter(n => n.popup)
    readonly property list<QtObject> history: list.filter(n => !n.popup)

    // Popup Settings

    property int popupAnimDuration: 350
    property int popupTimeoutLow: 3000
    property int popupTimeoutNormal: 5000
    property int popupTimeoutCritical: 0

    property bool expireLock: false // Helper for the expiration queue

    // Signals
    signal newNotification(var notif)
    signal notificationRemoved(var notif)
    signal notificationExpiring(var notif)


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Notification Server | |
    //  | `---------------------' |
    //  `-------------------------'

    property NotificationServer server: NotificationServer {
        id: server

        keepOnReload: false

        actionsSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: n => {
            n.tracked = true

            const obj = notifComponent.createObject(root, {
                notification: n,
                popup: !root.dnd
            })

            root.list = [obj, ...root.list]
            root.newNotification(obj)
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |     Public API      | |
    //  | `---------------------' |
    //  `-------------------------'

    function close(notif)    { if (notif) notif.close()    }
    function expire(notif)   { if (notif) notif.expire()   }
    function activate(notif) { if (notif) notif.activate() }

    function clearAll() {
        for (const n of list.slice()) n.close()
    }

    function toggleDnd() { root.dnd = !root.dnd }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |Notifications Wrapper| |
    //  | `---------------------' |
    //  `-------------------------'

    component Notif: QtObject {
        id: self

        property bool popup: true
        property bool closed: false
        property bool shown: false
        property bool shownPopup: false
        property bool closeAfterExpire: false

        property Notification notification

        property string id
        property string summary
        property string body
        property string appName
        property string appIcon
        property string image
        property int urgency
        property bool resident
        property list<var> actions
        property int expireTimeout
        property real progress: 0


        //  .-------------------------.
        //  | .---------------------. |
        //  | |     Lifecycle       | |
        //  | `---------------------' |
        //  `-------------------------'

        // Frontend popup timeout animation
        readonly property NumberAnimation progressAnim: NumberAnimation {
            target: self
            property: "progress"
            from: 0
            to: 1.0
            duration: expireTimeout
            running: expireTimeout > 0 && popup
            paused: expireLock
            onFinished: self.expire()
        }

        // Exit delay synced with frontend popup animation
        readonly property Timer expireDelay: Timer {
            interval: root.popupAnimDuration
            onTriggered: {
                self.popup = false
                root.expireLock = false
                if (self.closeAfterExpire) {
                    self.closeAfterExpire = false
                    self.close()
                }
            }
        }

        function close() {
            if (closed) return
            closed = true
            root.list = root.list.filter(n => n !== self)
            notification?.dismiss()
            root.notificationRemoved(self)
            destroy()
        }

        function expire() {
            if (closed) return
            if (!popup) return
            if (expireDelay.running) return
            expireLock = true
            progressAnim.stop()
            root.notificationExpiring(self)
            expireDelay.start()
        }

        function activate() {
            if (closed) return
            closeAfterExpire = true
            if (popup) {
                expire()
            } else {
                shown = false
                expireDelay.start()
            }
            if (!actions) return
            for (const a of actions) {
                if (a.identifier === "default") {
                    a.invoke()
                    break
                }
            }
        }


        //  .-------------------------.
        //  | .---------------------. |
        //  | |    Sync w/ Notif    | |
        //  | `---------------------' |
        //  `-------------------------'

        readonly property Connections conn: Connections {
            target: self.notification

            function onClosed() { if (!self.expireDelay.running) self.close() }
            function onSummaryChanged() { self.summary = notification.summary }
            function onBodyChanged() { self.body = notification.body }
            function onAppNameChanged() {
                const desktopEntry = (notification.hints || {})["desktop-entry"]
                self.appName = notification.appName || desktopEntry || LanguageManager.t("notifications.system")
            }
            function onAppIconChanged() { self.appIcon = notification.appIcon }
            function onImageChanged() { self.image = notification.image }
            function onUrgencyChanged() { self.urgency = notification.urgency }
            function onResidentChanged() { self.resident = notification.resident }
            function onActionsChanged() {
                self.actions = notification.actions.map(a => ({
                    identifier: a.identifier,
                    text: a.text,
                    invoke: () => a.invoke()
                }))
            }
        }

        Component.onCompleted: {
            if (!notification) return

            id = notification.id
            summary = notification.summary
            body = notification.body
            const desktopEntry = (notification.hints || {})["desktop-entry"]
            appName = notification.appName || desktopEntry || LanguageManager.t("notifications.system")
            appIcon = notification.appIcon
            image = notification.image
            urgency = notification.urgency
            resident = notification.resident

            if (notification.expireTimeout > 0) {
                expireTimeout = notification.expireTimeout
            } else {
                if (urgency === 0)      expireTimeout = root.popupTimeoutLow
                else if (urgency === 1) expireTimeout = root.popupTimeoutNormal
                else                    expireTimeout = root.popupTimeoutCritical
            }

            actions = notification.actions.map(a => ({
                identifier: a.identifier,
                text: a.text,
                invoke: () => a.invoke()
            }))
        }
    }

    property Component notifComponent: Component {
        id: notifComponent
        Notif {}
    }
}