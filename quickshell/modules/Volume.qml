// File: quickshell/modules/Volume.qml
//
// The polybar [module/pulseaudio] replacement. polybar pinned one sink by
// name; this prefers the same sink and falls back to whatever pipewire calls
// the default, so a hardware change does not blank the module.
import Quickshell.Services.Pipewire
import QtQuick

Text {
    id: root

    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // polybar: sink = alsa_output.pci-0000_c1_00.6.pro-output-0
    readonly property string sinkName: "alsa_output.pci-0000_c1_00.6.pro-output-0"

    readonly property var sink: {
        var nodes = Pipewire.nodes.values;
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].name === sinkName) return nodes[i];
        }
        return Pipewire.defaultAudioSink;
    }

    readonly property var audio: sink ? sink.audio : null
    readonly property bool muted: audio ? audio.muted : false
    readonly property int percent: audio ? Math.round(audio.volume * 100) : 0

    // polybar: label-volume = "<volume icon> %percentage:3%%"
    //          format-muted-prefix = "<mute icon> ",
    //          label-muted = %percentage:2%%
    text: muted
          ? "\u{f075f} " + String(percent).padStart(2, " ") + "%"
          : "\uf028 " + String(percent).padStart(3, " ") + "%"

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    // Binding a pipewire node is what makes its volume and mute state
    // readable, and writable: that is all PwObjectTracker is for.
    PwObjectTracker {
        objects: [root.sink]
    }

    // polybar's pulseaudio module took a click to mute and a scroll to change
    // the volume. The step is 5%, the same step the i3 keybindings use, and it
    // is applied to the same sink this module displays.
    readonly property real volumeStep: 0.05

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.audio) root.audio.muted = !root.audio.muted;
        }

        onWheel: function (wheel) {
            if (!root.audio) return;
            var next = root.audio.volume + (wheel.angleDelta.y > 0 ? volumeStep : -volumeStep);
            root.audio.volume = Math.max(0, Math.min(1, next));
        }
    }
}
