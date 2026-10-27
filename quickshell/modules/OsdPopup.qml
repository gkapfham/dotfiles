// File: quickshell/modules/OsdPopup.qml
//
// A transient on-screen display for volume and brightness.
//
// The bar already shows both numbers, but the bar is 30px of a screen that is
// usually full of windows, so an OSD that appears where the eye already is
// helps when the keys are pressed with something else in front.
//
// It watches the values rather than being told about them, so it lights up for
// every source: the i3 keybindings (`pactl`, `brightnessctl`), the bar's own
// scroll wheel, and an application changing its own volume.
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick

PopupWindow {
    id: osd

    required property var barWindow
    required property QtObject colors
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // Centred in the screen area below the bar, so it never lands under the
    // clock or the workspace row.
    anchor.window: barWindow
    anchor.rect.x: Math.round((barWindow.width - width) / 2)
    anchor.rect.y: Math.round(barWindow.height
                              + (barWindow.screen.height - barWindow.height - height) / 2)

    // No grabFocus on purpose: an OSD must not take the keyboard away from
    // whatever the user is doing.
    visible: false
    implicitWidth: 240
    implicitHeight: 78
    color: colors.background

    property string icon: ""
    property string label: ""
    property real level: 0

    // The first reading of each value arrives when quickshell starts, and the
    // volume arrives again whenever the pipewire node is bound. Neither is a
    // change the user made, so the first reading of each is recorded and
    // swallowed rather than flashed. Later readings are also compared against
    // the last one, because pipewire re-announces a node's volume on events
    // that are not volume changes.
    property int volumePercent: -1
    property bool volumeMuted: false

    // ---------------------------------------------------------------- volume
    //
    // Same sink the volume module shows: the one polybar/config.ini pinned,
    // falling back to whatever pipewire calls the default.
    readonly property string sinkName: "alsa_output.pci-0000_c1_00.6.pro-output-0"

    readonly property var sink: {
        var nodes = Pipewire.nodes.values;
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].name === sinkName) return nodes[i];
        }
        return Pipewire.defaultAudioSink;
    }

    readonly property var audio: sink ? sink.audio : null

    // A pipewire node has to be bound before its volume and mute state are
    // readable; that is all PwObjectTracker is for.
    PwObjectTracker {
        objects: [osd.sink]
    }

    Connections {
        target: osd.audio

        function onVolumesChanged() { osd.showVolume(); }
        function onMutedChanged() { osd.showVolume(); }
    }

    // ------------------------------------------------------------ brightness
    //
    // sysfs gives no change notification for these files, so they are polled.
    // It is one small file read four times a second, which is what buys an OSD
    // that appears on the same frame as the brightness key.
    readonly property string backlightCard: "/sys/class/backlight/amdgpu_bl1"

    // -1 until the first reading, so the startup read can be told apart from a
    // real change.
    property int brightnessPercent: -1

    FileView {
        id: brightness
        path: osd.backlightCard + "/brightness"
        onTextChanged: osd.checkBrightness()
    }

    FileView {
        id: brightnessMax
        path: osd.backlightCard + "/max_brightness"
        onTextChanged: osd.checkBrightness()
    }

    Timer {
        interval: 250
        repeat: true
        running: true

        onTriggered: {
            brightness.reload();
            brightnessMax.reload();
        }
    }

    // -------------------------------------------------------------- the box
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: osd.colors.primary
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Text {
                text: osd.icon
                color: osd.colors.foreground
                font.family: osd.fontFamily
                font.pixelSize: osd.fontSize
                font.bold: osd.fontBold
                renderType: Text.CurveRendering
            }

            Text {
                text: osd.label
                color: osd.colors.foreground
                font.family: osd.fontFamily
                font.pixelSize: osd.fontSize
                font.bold: osd.fontBold
                renderType: Text.CurveRendering
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 184
            height: 8
            color: osd.colors.primary

            Rectangle {
                width: Math.round(parent.width * Math.max(0, Math.min(1, osd.level)))
                height: parent.height
                color: osd.colors.foreground
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 1400
        onTriggered: osd.visible = false
    }

    function flash() {
        osd.visible = true;
        hideTimer.restart();
    }

    function showVolume() {
        if (!osd.audio) return;

        var percent = Math.round(osd.audio.volume * 100);
        var muted = osd.audio.muted;
        if (percent === osd.volumePercent && muted === osd.volumeMuted) return;

        var firstReading = osd.volumePercent < 0;
        osd.volumePercent = percent;
        osd.volumeMuted = muted;
        if (firstReading) return;

        osd.icon = muted ? "\u{f075f}" : "\u{f028}";
        osd.label = percent + "%";
        osd.level = osd.audio.volume;
        osd.flash();
    }

    function checkBrightness() {
        var current = parseInt(brightness.text().trim(), 10);
        var max = parseInt(brightnessMax.text().trim(), 10);
        if (isNaN(current) || isNaN(max) || max <= 0) return;

        var percent = Math.round(current / max * 100);
        if (osd.brightnessPercent === percent) return;

        var firstReading = osd.brightnessPercent < 0;
        osd.brightnessPercent = percent;

        if (firstReading) return;
        osd.showBrightness(percent);
    }

    function showBrightness(percent) {
        // The same ramp the backlight module draws.
        osd.icon = percent <= 20 ? "\u{f00de}"
                 : percent <= 60 ? "\u{f00df}"
                 : percent <= 80 ? "\u{f00dd}"
                 : "\u{f00e0}";
        osd.label = percent + "%";
        osd.level = percent / 100;
        osd.flash();
    }
}
