// File: quickshell/modules/CalendarPopup.qml
//
// A calendar for the date module. This is the one thing the polybar bar could
// not do at all: a bar module that opens its own window. Quickshell's
// PopupWindow anchors a real window under the bar, and grabFocus dismisses it
// when the user clicks anywhere else, so no keybinding or helper script is
// needed to close it.
//
// Click the month name to come back to the current month.
import Quickshell
import QtQuick

PopupWindow {
    id: popup

    required property var anchorWindow
    required property QtObject colors
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // Just under the right-hand end of the bar, which is where the date is.
    anchor.window: anchorWindow
    anchor.rect.x: anchorWindow.width - width - 8
    anchor.rect.y: anchorWindow.height

    grabFocus: true
    visible: false

    implicitWidth: 232
    implicitHeight: 196
    color: colors.background

    // Which month is on screen; 0 is the current one.
    property int monthOffset: 0

    readonly property var shownMonth: {
        var now = new Date();
        return new Date(now.getFullYear(), now.getMonth() + monthOffset, 1);
    }

    readonly property bool showingCurrentMonth: monthOffset === 0

    // 42 cells: the blanks before the first, then the days, then blanks.
    // getDay() is 0 for Sunday, which is how the weekday row below is ordered.
    readonly property var cells: {
        var first = shownMonth;
        var lead = first.getDay();
        var count = new Date(first.getFullYear(), first.getMonth() + 1, 0).getDate();
        var out = [];
        for (var i = 0; i < 42; i++) {
            var day = i - lead + 1;
            out.push(day >= 1 && day <= count ? day : 0);
        }
        return out;
    }

    readonly property var weekdayNames: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    function todayDay() {
        return new Date().getDate();
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: popup.colors.primary
    }

    Column {
        anchors.centerIn: parent
        spacing: 6

        // Header: previous month, the month itself (click to jump back to
        // today's month), next month.
        Row {
            spacing: 10

            Text {
                text: "\u2039"
                color: popup.colors.foreground
                font.family: popup.fontFamily
                font.pixelSize: popup.fontSize
                font.bold: popup.fontBold
                renderType: Text.CurveRendering

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: popup.monthOffset -= 1
                }
            }

            Text {
                text: Qt.formatDate(popup.shownMonth, "MMMM yyyy")
                color: popup.colors.foreground
                font.family: popup.fontFamily
                font.pixelSize: popup.fontSize
                font.bold: popup.fontBold
                renderType: Text.CurveRendering

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: popup.monthOffset = 0
                }
            }

            Text {
                text: "\u203a"
                color: popup.colors.foreground
                font.family: popup.fontFamily
                font.pixelSize: popup.fontSize
                font.bold: popup.fontBold
                renderType: Text.CurveRendering

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: popup.monthOffset += 1
                }
            }
        }

        // Weekday headings.
        Row {
            spacing: 0

            Repeater {
                model: popup.weekdayNames

                delegate: Text {
                    required property string modelData
                    width: 28
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    color: popup.colors.foregroundAlt
                    font.family: popup.fontFamily
                    font.pixelSize: popup.fontSize
                    font.bold: popup.fontBold
                    renderType: Text.CurveRendering
                }
            }
        }

        // The days themselves. Today gets the same focused-workspace pill the
        // bar uses, so the two read the same way.
        Grid {
            columns: 7
            spacing: 0

            Repeater {
                model: popup.cells

                delegate: Item {
                    required property int modelData
                    width: 28
                    height: 20

                    Rectangle {
                        anchors.centerIn: parent
                        width: 24
                        height: 18
                        color: (modelData > 0 && popup.showingCurrentMonth
                                && modelData === popup.todayDay())
                               ? popup.colors.primary
                               : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData > 0 ? modelData : ""
                            color: popup.colors.foreground
                            font.family: popup.fontFamily
                            font.pixelSize: popup.fontSize
                            font.bold: popup.fontBold
                            renderType: Text.CurveRendering
                        }
                    }
                }
            }
        }
    }
}
