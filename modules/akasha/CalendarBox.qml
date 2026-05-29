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
import qs.themes

Rectangle {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    color: "transparent"

    // Calendar Logic
    property date currentDate: new Date()
    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    property var months: [
        LanguageManager.t("calendar.january"),
        LanguageManager.t("calendar.february"),
        LanguageManager.t("calendar.march"),
        LanguageManager.t("calendar.april"),
        LanguageManager.t("calendar.may"),
        LanguageManager.t("calendar.june"),
        LanguageManager.t("calendar.july"),
        LanguageManager.t("calendar.august"),
        LanguageManager.t("calendar.september"),
        LanguageManager.t("calendar.october"),
        LanguageManager.t("calendar.november"),
        LanguageManager.t("calendar.december")
    ]

    property var days: [
        LanguageManager.t("calendar.sun"),
        LanguageManager.t("calendar.mon"),
        LanguageManager.t("calendar.tue"),
        LanguageManager.t("calendar.wed"),
        LanguageManager.t("calendar.thu"),
        LanguageManager.t("calendar.fri"),
        LanguageManager.t("calendar.sat")
    ]

    function getDaysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate()
    }

    function getFirstDayOffset(month, year) {
        return new Date(year, month, 1).getDay()
    }

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

    // Calendar
    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        spacing: 5

        // Header: Month Year and Controls
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.months[root.currentMonth] + " " + root.currentYear
                color: ThemeManager.colors.green
                font.family: ThemeManager.fonts.main
                font.bold: true
                font.pixelSize: 18
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 15

                // Previous Button
                Text {
                    text: "◀"
                    color: ThemeManager.colors.yellow
                    font.pixelSize: 16
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.currentMonth === 0) {
                                root.currentMonth = 11
                                root.currentYear--
                            } else {
                                root.currentMonth--
                            }
                        }
                    }
                }

                // Next Button
                Text {
                    text: "▶"
                    color: ThemeManager.colors.yellow
                    font.pixelSize: 16
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.currentMonth === 11) {
                                root.currentMonth = 0
                                root.currentYear++
                            } else {
                                root.currentMonth++
                            }
                        }
                    }
                }
            }
        }

        // Days of the week
        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: root.days
                Item {
                    Layout.fillWidth: true
                    height: 20
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: ThemeManager.colors.mauve
                        font.family: ThemeManager.fonts.main
                        font.pixelSize: 14
                    }
                }
            }
        }

        // Day Grid
        GridLayout {
            columns: 7
            rows: 6
            columnSpacing: 0
            rowSpacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: 42 // 6 rows * 7 columns to cover any month

                delegate: Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Calculations
                    property int daysInCurrentMonth: root.getDaysInMonth(root.currentMonth, root.currentYear)
                    property int dayOffset: root.getFirstDayOffset(root.currentMonth, root.currentYear)

                    // Previous month
                    property int prevMonth: root.currentMonth === 0 ? 11 : root.currentMonth - 1
                    property int prevMonthYear: root.currentMonth === 0 ? root.currentYear - 1 : root.currentYear
                    property int daysInPrevMonth: root.getDaysInMonth(prevMonth, prevMonthYear)

                    // Cell State
                    property bool isPrevMonthDay: index < dayOffset
                    property bool isNextMonthDay: index >= dayOffset + daysInCurrentMonth
                    property bool isCurrentMonthDay: !isPrevMonthDay && !isNextMonthDay

                    // Day Number
                    property int dayNumber: {
                        if (isPrevMonthDay) {
                            return daysInPrevMonth - (dayOffset - 1 - index);
                        } else if (isNextMonthDay) {
                            return index - (dayOffset + daysInCurrentMonth) + 1;
                        } else { // isCurrentMonthDay
                            return index - dayOffset + 1;
                        }
                    }

                    // Today Check
                    property bool isToday: {
                        let today = new Date();
                        return isCurrentMonthDay &&
                               dayNumber === today.getDate() &&
                               root.currentMonth === today.getMonth() &&
                               root.currentYear === today.getFullYear();
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 30
                        height: 30
                        radius: 15
                        color: isToday ? ThemeManager.colors.sky : "transparent";

                        Text {
                            anchors.centerIn: parent
                            text: dayNumber
                            color: {
                                if (isToday) return ThemeManager.colors.base;
                                if (isCurrentMonthDay) return ThemeManager.colors.text;
                                return ThemeManager.colors.surface2; // Color for other months' days
                            }
                            font.family: ThemeManager.fonts.main
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}