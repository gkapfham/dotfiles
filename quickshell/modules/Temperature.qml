// File: quickshell/modules/Temperature.qml
//
// The polybar [module/temperature] replacement, used three times: once for the
// CPU (cros_ec), once for the GPU (amdgpu) and once for the SSD (nvme).
//
// NOTE: the three hwmon paths in Bar.qml are the same hardcoded ones polybar
// used. The hwmonN numbers are assigned at boot and can move, which is why
// polybar/scripts/fan resolves its device by driver name instead. If a
// temperature ever reads nothing, check /sys/class/hwmon/*/name and update the
// paths in Bar.qml.
import Quickshell.Io
import QtQuick

Text {
    id: root

    required property string path
    property string prefix: ""
    property int interval: 10
    property bool units: true
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    property int celsius: 0

    // polybar: label = "<icon> %temperature-c:2%" and, because `units` is not
    // set to false, polybar appends the unit itself.
    text: prefix + String(celsius).padStart(2, " ") + (units ? "\u00b0C" : "")

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
        id: sensor

        path: root.path
        watchChanges: false

        onTextChanged: {
            var milli = parseInt(sensor.text().trim(), 10);
            if (!isNaN(milli)) root.celsius = Math.round(milli / 1000);
        }
    }

    Timer {
        interval: root.interval * 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: sensor.reload()
    }
}
