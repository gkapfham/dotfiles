// File: quickshell/Colors.qml
//
// The colors the bar draws with. Every value is copied verbatim from the
// [colors] block of polybar/config.ini, so switching from polybar to
// quickshell changes nothing about the color scheme -- not even the entries
// that are currently unused.
//
// theme/palette.toml is the canonical source of truth for these values and
// theme/sync_palette.py audits this file along with the others (see TARGETS
// in that script), exactly as it audits polybar/config.ini today.
import QtQuick

QtObject {
    // Define colors to be centered by dark grey
    // Some of these colors are not used now
    readonly property color background: "#1c1c1c"
    readonly property color backgroundAlt: "#c6c6c6"
    readonly property color foreground: "#e0e0e0"
    readonly property color foregroundAlt: "#a8a8af"
    readonly property color primary: "#444444"
    // readonly property color secondary: "#87afd7"
    readonly property color secondary: "#a569a5"
    readonly property color alert: "#616161"
    readonly property color green: "#009300"
    readonly property color yellow: "#e95420"
    readonly property color red: "#f90000"
    readonly property color blue: "#0a6cf5"
    readonly property color sepBright: "#5a5a5a"
}
