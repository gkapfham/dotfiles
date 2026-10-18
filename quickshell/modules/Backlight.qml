// File: quickshell/modules/Backlight.qml
//
// The polybar [module/backlight] replacement. polybar was told
// `use-actual-brightness = false`, i.e. show the brightness that was asked
// for rather than the value the hardware settled on, so this reads
// `brightness` and not `actual_brightness`.
import Quickshell.Io
import QtQuick

Text {
    id: root

    property int interval: 15
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // polybar: card = amdgpu_bl1
    readonly property string card: "/sys/class/backlight/amdgpu_bl1"

    property int percent: 0

    // polybar: format = <ramp> <label>, format-prefix = " ",
    //          label = %percentage:3%%
    text: " " + ramp(percent) + " " + String(percent).padStart(3, " ") + "%"

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    // polybar ramp-0..ramp-4, in order (ramp-1 and ramp-2 are the same glyph).
    function ramp(value) {
        var glyphs = [
            "\u{f00de}",
            "\u{f00df}",
            "\u{f00df}",
            "\u{f00dd}",
            "\u{f00e0}"
        ];
        var index = Math.round(value / 100 * (glyphs.length - 1));
        if (index < 0) index = 0;
        if (index > glyphs.length - 1) index = glyphs.length - 1;
        return glyphs[index];
    }

    FileView {
        id: brightness

        path: root.card + "/brightness"
        watchChanges: false

        onTextChanged: root.update()
    }

    FileView {
        id: maximum

        path: root.card + "/max_brightness"
        watchChanges: false

        onTextChanged: root.update()
    }

    Timer {
        interval: root.interval * 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            brightness.reload();
            maximum.reload();
        }
    }

    function update() {
        var current = parseInt(brightness.text().trim(), 10);
        var max = parseInt(maximum.text().trim(), 10);
        if (!isNaN(current) && !isNaN(max) && max > 0) {
            root.percent = Math.round(current / max * 100);
        }
    }

    // polybar's backlight module changed the brightness on scroll. The sysfs
    // files here are root-owned, so this goes through brightnessctl -- the very
    // command the i3 brightness keybindings use, with the same 5% step.
    Process {
        id: setter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onWheel: function (wheel) {
            setter.exec([
                "brightnessctl", "set",
                wheel.angleDelta.y > 0 ? "5%+" : "5%-"
            ]);
        }
    }
}
