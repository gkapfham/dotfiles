// File: quickshell/modules/Netbird.qml
//
// A NetBird indicator that doubles as its switch, in the status plate beside
// bluetooth. Not a polybar module.
//
// quickshell has no NetBird service, so this runs the CLI -- the same binary
// that works in a terminal. That is worth stating plainly, because it is the
// whole question: the bar is allowed to do this. NetBird authorises its clients
// by the daemon socket alone, with no per-command check, and /run/netbird/sock
// is srw-rw-rw- on this machine, so an unprivileged process may call up and
// down exactly as the user's shell does. No sudo, no polkit rule, nothing to
// install.
//
// State comes from `netbird status --json`, which costs ~19ms of CPU per call
// (measured; it is a gRPC round trip over that socket, not a process scan). The
// field that matters for a switch is management.connected: it says the tunnel
// is up and registered with the management server. Peer counts deliberately do
// not matter: "6/10 peers connected" is a healthy mesh, and keying the icon off
// it would dim the icon while the VPN was working perfectly.
//
// The poll is 15s, plus a 1s settle poll for 15s after a click, so the icon
// follows the click that caused the change rather than the timer. Like every
// other module in Bar.qml this runs once per screen.
import Quickshell.Io
import QtQuick

Text {
    id: root

    // The bright colour, passed in by the bar, and the dim one for "not
    // connected". `color` itself must stay free for the binding below: a
    // component that binds `color` to itself and also lets its parent assign
    // `color` has that binding replaced at load, which is why the bluetooth
    // glyph beside this one never dims.
    property color activeColor: "#e0e0e0"
    property color dimColor: "#a8a8af"

    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // nf-md-bird. The product is a bird, and this is the one glyph in the set
    // that is unmistakably one at 13 logical px (26 physical px on both
    // panels). The icon font has no bird-off, so "not connected" is the same
    // glyph dimmed -- the convention the agent icon already uses for "nothing
    // running" -- rather than a second, unrelated shape.
    readonly property string icon: "\u{f15c6}"

    // False until a reading says otherwise, so a stopped daemon and a bar that
    // has not asked yet both show the same honest "not up".
    property bool connected: false

    // True from the click until the switch command exits, so a second click
    // cannot start a second up/down.
    property bool busy: false

    // Reads left in the post-toggle settle poll; see the second Timer.
    property int settleTicks: 0

    text: root.icon
    color: root.connected ? root.activeColor : root.dimColor

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

        onClicked: root.toggle()
    }

    Process {
        id: statusProc

        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }

    Process {
        id: switchProc

        onExited: {
            root.busy = false;
            // Read the result now rather than at the next beat: the settle poll
            // may have spent itself while the daemon was still coming up.
            root.refresh();
        }
    }

    Timer {
        interval: 15000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: root.refresh()
    }

    Timer {
        id: settle

        interval: 1000
        repeat: true
        running: root.settleTicks > 0

        onTriggered: {
            root.settleTicks -= 1;
            root.refresh();
        }
    }

    function refresh() {
        statusProc.exec(["netbird", "status", "--json"]);
    }

    function toggle() {
        if (root.busy) return;

        root.busy = true;
        root.settleTicks = 15;
        // A profile that still needs a login makes `up` block until its own
        // timeout while it prints a browser URL nobody sees here; the click
        // then simply does nothing visible, and the icon stays dim, which is
        // the truthful outcome.
        switchProc.exec(["netbird", root.connected ? "down" : "up"]);
    }

    function parse(text) {
        var status;

        try {
            status = JSON.parse(text);
        } catch (e) {
            // Anything that is not the daemon's JSON means the tunnel is not
            // usable: service stopped, needs login, or the call was cut short.
            // The icon must not keep claiming "connected" in that case.
            root.connected = false;
            return;
        }

        root.connected = !!(status.management && status.management.connected === true);
    }
}
