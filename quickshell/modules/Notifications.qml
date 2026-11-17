// File: quickshell/modules/Notifications.qml
//
// A notification bell for dunst's history.
//
// quickshell has a notification service of its own, but only one process can
// own org.freedesktop.Notifications and dunst already does, so this reads
// dunst's history through dunstctl instead of competing with it. dunst keeps
// the last 20 by default and offers no way to re-show an arbitrary one, only
// the most recent, which is what a click does here.
//
// The bell is dimmed while the history is empty. That is the only state
// available to show: the history is a fixed-size ring buffer, so a count would
// read "20" most of the time and mean nothing.
//
// Left-click re-shows the most recent history entry; right-click dismisses
// everything currently on screen. Dismissing does not touch the history, so a
// notification cleared by accident is still one left-click away.
import Quickshell.Io
import QtQuick

Text {
    id: root

    property color dimColor: "#a8a8af"
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    readonly property string bellIcon: "\u{f009a}"

    // Asks the bar to open the full history list.
    signal listRequested()

    // -1 until the first reading, so an empty history is not assumed before
    // dunstctl has actually answered.
    property int historyCount: -1

    text: bellIcon
    color: root.historyCount === 0 ? root.dimColor : root.color

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    Process {
        id: counter

        stdout: StdioCollector {
            onStreamFinished: {
                var count = parseInt(text.trim(), 10);
                if (!isNaN(count)) root.historyCount = count;
            }
        }
    }

    Process {
        id: dunstCtl
    }

    Timer {
        interval: 10000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: counter.exec(["dunstctl", "count", "history"])
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                if (mouse.modifiers & Qt.ShiftModifier) {
                    // Shift+right: dismiss everything on screen in one go.
                    root.closeAllNow();
                } else {
                    // Right: keep the original one-at-a-time behaviour.
                    root.restoreLatest();
                }
            } else {
                // Left: the full, scrollable, source-grouped list.
                root.listRequested();
            }
        }
    }

    Timer {
        id: refresh
        interval: 300
        onTriggered: counter.exec(["dunstctl", "count", "history"])
    }

    function restoreLatest() {
        dunstCtl.exec(["dunstctl", "history-pop"]);
        refreshNow();
    }

    function closeAllNow() {
        dunstCtl.exec(["dunstctl", "close-all"]);
        refreshNow();
    }

    // Called by the list after it changes the history, so the bell's count is
    // right immediately.
    function refreshNow() {
        refresh.restart();
    }
}
