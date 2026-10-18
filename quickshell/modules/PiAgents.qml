// File: quickshell/modules/PiAgents.qml
//
// A robot for the pi coding agents running on this machine: how many there are,
// and, on click, a popup listing them by project, name and state.
//
// Not a polybar module -- polybar had no notion of an agent.
//
// The count is a bare `pgrep -x pi` on a timer, counted in QML rather than
// piped through `wc` so no shell is needed. The expensive half -- reading each
// agent's session file for its name -- is quickshell/scripts/pi-agents, which
// only the popup runs, so that cost is paid while the list is open instead of
// every ten seconds.
//
// The icon is dimmed when nothing is running, the same way the notification
// bell is dimmed when its history is empty.
import Quickshell.Io
import QtQuick

Text {
    id: root

    property color dimColor: "#a8a8af"
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    readonly property string robotIcon: "\u{f06a9}"

    // -1 until the first reading, so "none running" is not assumed before
    // pgrep has actually answered.
    property int agentCount: -1

    text: robotIcon + (root.agentCount > 0 ? " " + root.agentCount : "")
    color: root.agentCount === 0 ? root.dimColor : root.color

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
                // pgrep prints one pid per line and prints nothing when there is
                // no match, so counting non-empty lines is the whole job.
                var lines = text.split("\n").filter(function (line) {
                    return line.trim() !== "";
                });
                root.agentCount = lines.length;
            }
        }
    }

    // 60s, not 10s like the bell, because this poll is unusually expensive: it
    // scans the whole process table rather than asking one daemon a question.
    // Measured on this machine, `pgrep -x pi` costs about 39ms of CPU (mostly
    // sys, from reading /proc) against 6ms for the bell's `dunstctl count
    // history` and 8ms for a memory script. At 10s that would have been 0.39% of
    // a core, roughly a third of the bar's entire 1% -- for a number that only
    // changes when an agent starts or exits. At 60s it is 0.065%, in line with
    // the polls the bar already runs.
    Timer {
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: counter.exec(["pgrep", "-x", "pi"])
    }
}
