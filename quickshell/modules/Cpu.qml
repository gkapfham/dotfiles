// File: quickshell/modules/Cpu.qml
//
// The polybar [module/cpu] replacement. polybar sampled /proc/stat itself;
// this does the same, so the percentage means the same thing: the busy share
// of the interval since the previous reading.
import Quickshell.Io
import QtQuick

Text {
    id: root

    property int interval: 10
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    property real lastTotal: 0
    property real lastIdle: 0
    property int percent: 0

    // polybar: label = "<cpu icon> %percentage:2%%"
    text: "\ue7b2 " + String(percent).padStart(2, " ") + "%"

    // No shorter form: both widths are the same, so the bar treats this
    // module as one fixed size.
    readonly property real fullWidth: implicitWidth
    readonly property real compactWidth: implicitWidth

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    FileView {
        id: stat

        path: "/proc/stat"
        watchChanges: false

        onTextChanged: root.sample()
    }

    Timer {
        interval: root.interval * 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: stat.reload()
    }

    // "cpu  user nice system idle iowait irq softirq steal guest guest_nice"
    function sample() {
        var fields = stat.text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
        if (fields.length < 4) return;

        var idle = fields[3] + (fields[4] || 0);
        var total = 0;
        for (var i = 0; i < fields.length; i++) total += fields[i];

        if (root.lastTotal > 0 && total > root.lastTotal) {
            var dTotal = total - root.lastTotal;
            var dIdle = idle - root.lastIdle;
            root.percent = Math.round(100 * (dTotal - dIdle) / dTotal);
        }

        root.lastTotal = total;
        root.lastIdle = idle;
    }
}
