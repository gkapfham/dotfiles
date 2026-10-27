// File: quickshell/modules/ScriptModule.qml
//
// A polybar `custom/script` module: run a command every `interval` seconds
// and show its output. The commands are polybar's own scripts in
// polybar/scripts/, unchanged, so the bar prints exactly the same text.
//
// Modules that have a shorter form (polybar's memory and filesystem scripts
// both take a "short" argument) run *both* commands and measure both results.
// The bar then decides per paint whether the long form fits, exactly the way
// polybar's laptop/external split wanted to but could not, because polybar
// had to pick a module list up front from the monitor width.
import Quickshell.Io
import QtQuick

Text {
    id: root

    required property var command
    property var compactCommand: []
    property bool compact: false
    property int interval: 10
    property string prefix: ""
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    property string fullOutput: ""
    property string compactOutput: ""

    // The scripts print one line each; take the last one so a re-run can never
    // leave two readings glued together.
    function lastLine(text) {
        var lines = text.split("\n").filter(function (l) { return l.trim() !== ""; });
        return lines.length > 0 ? lines[lines.length - 1].trim() : "";
    }

    readonly property string longText: prefix + fullOutput
    readonly property string shortText: compactCommand.length > 0
                                        ? prefix + compactOutput
                                        : prefix + fullOutput

    readonly property bool hasShortForm: compactCommand.length > 0

    // Both widths are measured regardless of which one is on screen, so the
    // bar can size the block without the answer depending on its own result.
    readonly property real fullWidth: longMetrics.advanceWidth
    readonly property real compactWidth: shortMetrics.advanceWidth

    text: (compact && hasShortForm) ? shortText : longText

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    TextMetrics {
        id: longMetrics
        font: root.font
        text: root.longText
    }

    TextMetrics {
        id: shortMetrics
        font: root.font
        text: root.shortText
    }

    Process {
        id: longProc
        stdout: StdioCollector {
            id: longOut

            // Read the output once the stream closes rather than on every
            // chunk, so a partial line is never measured.
            onStreamFinished: root.fullOutput = root.lastLine(text)
        }
    }

    Process {
        id: shortProc
        stdout: StdioCollector {
            id: shortOut

            onStreamFinished: root.compactOutput = root.lastLine(text)
        }
    }

    Timer {
        interval: root.interval * 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            longProc.exec(root.command);
            if (root.hasShortForm) shortProc.exec(root.compactCommand);
        }
    }
}
