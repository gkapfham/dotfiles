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
                // Dismiss what is on screen. The history is left alone, so
                // anything closed by mistake can still be brought back with a
                // left click.
                dunstCtl.exec(["dunstctl", "close-all"]);
            } else {
                // history-pop puts the most recent entry back on screen and
                // takes it out of the history.
                dunstCtl.exec(["dunstctl", "history-pop"]);
            }

            // Refresh straight away rather than waiting for the next poll.
            refresh.restart();
        }
    }

    Timer {
        id: refresh
        interval: 300
        onTriggered: counter.exec(["dunstctl", "count", "history"])
    }
}
