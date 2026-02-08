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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

QtObject {
    id: root

    // =========================
    // CONFIG / STATE
    // =========================

    property bool dnd: false            // Do Not Disturb

    // Lista principal de notificaciones
    // cada entrada es un objeto wrapper
    property list<QtObject> list: []

    // Derivados útiles
    readonly property list<QtObject> popups: list.filter(n => n.popup)
    readonly property list<QtObject> history: list.filter(n => !n.popup)

    signal newNotification(var notif)
    signal notificationRemoved(var notif)

    // =========================
    // NOTIFICATION SERVER
    // =========================

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

    // =========================
    // PUBLIC API
    // =========================

    function close(notif) {
        if (!notif) return
        notif.close()
    }

    function expire(notif) {
        if (!notif) return
        notif.expire()
    }

    function activate(notif) {
        if (!notif) return
        notif.activate()
    }

    function clearAll() {
        for (const n of list.slice())
            n.close()
    }

    function toggleDnd() {
        root.dnd = !root.dnd
    }

    // =========================
    // NOTIFICATION WRAPPER
    // =========================

    component Notif: QtObject {
        id: self

        // --- runtime ---
        property bool popup: true
        property bool closed: false
        property bool shown: false

        // --- raw notification ---
        property Notification notification

        // --- mirrored fields (para UI fácil) ---
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

        // =========================
        // LIFECYCLE
        // =========================

        readonly property Timer expireTimer: Timer {
            running: expireTimeout > 0 && popup
            interval: expireTimeout
            onTriggered: self.popup = false
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
            popup = false
        }

        function activate() {
            if (!actions) return
            for (const a of actions) {
                if (a.identifier === "default") {
                    a.invoke()
                    break
                }
            }
            close()
        }

        // =========================
        // SYNC CON NOTIFICATION
        // =========================

        readonly property Connections conn: Connections {
            target: self.notification

            function onClosed() { self.close() }
            function onSummaryChanged() { self.summary = notification.summary }
            function onBodyChanged() { self.body = notification.body }
            function onAppNameChanged() {
                const desktopEntry = (notification.hints || {})["desktop-entry"]
                self.appName = notification.appName || desktopEntry || "System"
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
            appName = notification.appName || desktopEntry || "System"
            appIcon = notification.appIcon
            image = notification.image
            urgency = notification.urgency
            resident = notification.resident

            if (notification.expireTimeout > 0) {
                expireTimeout = notification.expireTimeout
            } else {
                if (urgency === 0) expireTimeout = 3000      // Low
                else if (urgency === 1) expireTimeout = 5000 // Normal
                else expireTimeout = 0                       // Critical
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
