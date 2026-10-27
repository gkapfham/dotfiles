// File: quickshell/modules/Bluetooth.qml
//
// A bluetooth indicator, which the polybar bar had nothing for. Clicking it
// toggles the adapter, so the icon is also the switch: it shows the filled
// bluetooth glyph while the radio is on and the slashed one, dimmed, while it
// is off.
import Quickshell.Bluetooth
import QtQuick

Text {
    id: root

    property color dimColor: "#a8a8af"
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    readonly property string onIcon: "\u{f00af}"
    readonly property string offIcon: "\u{f00b2}"

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool enabled: available ? adapter.enabled : false

    text: enabled ? onIcon : offIcon
    color: enabled ? root.color : root.dimColor

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.available) root.adapter.enabled = !root.adapter.enabled;
        }
    }
}
