// File: quickshell/modules/PiAgentsPopup.qml
//
// Opened by clicking the robot in the bar: every pi coding agent running on
// this machine, by project, session name and state.
//
// The data comes from quickshell/scripts/pi-agents, which pairs each running
// `pi` process with a session file and reads that session's name. See the
// script for where the session comes from and how exact that is; the short
// version is that an agent started after pi/extensions/agent-registry.ts was
// installed reports its session exactly, and everything else is inferred.
//
// The status glyphs are the state at a glance:
//
//     filled  active    a run is in progress right now
//     half    idle      waiting for input, session touched within a day
//     hollow  dormant   waiting for input, untouched for longer
//     middle  unknown   running, but no session file to judge by
//
// The age beside each name is time since the session file was last written.
import Quickshell
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    // null until the first read finishes, so the popup does not claim that
    // nothing is running while the script is still starting.
    property var agents: null

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/pi-agents"

    title: "Pi Agents"
    // Room for the glyph plus a project directory name, which is the long half
    // of the left column.
    labelWidth: 150
    popupWidth: 560

    rows: popup.agents === null
          ? [{ label: "Agents", value: "\u2026" }]
          : popup.agents.length > 0
            ? popup.agents
            : [{ label: "Agents", value: "none running" }]

    Process {
        id: lister

        stdout: StdioCollector {
            onStreamFinished: popup.parse(text)
        }
    }

    // Polled only while the popup is open. Opening restarts the timer from the
    // top, so the list is always fresh on the first paint.
    //
    // 15s rather than 5s: one run costs about 0.34s of CPU and spawns 85
    // processes, since it reads a session file per agent. At 5s that is 6.8% of
    // a core for as long as the popup is left open; at 15s it is 2.3%. Nothing
    // in the list changes faster than that.
    Timer {
        interval: 15000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: lister.exec([popup.scriptPath])
    }

    // One line per agent: status, project, name, idle seconds, source.
    function parse(text) {
        var out = [];
        var lines = text.split("\n");

        for (var i = 0; i < lines.length; i++) {
            if (lines[i].trim() === "") continue;

            var field = lines[i].split("\t");
            if (field.length < 4) continue;

            var status = field[0];
            var name = field[2];
            var age = popup.shortAge(parseInt(field[3], 10));

            out.push({
                // The glyph carries the state, so the colour is reinforcement
                // rather than the only signal.
                label: popup.statusGlyph(status) + " " + field[1],
                value: age === "" ? name : name + "  " + age,
                color: popup.statusColor(status)
            });
        }

        popup.agents = out;
    }

    function statusGlyph(status) {
        if (status === "active") return "\u25cf";   // filled circle
        if (status === "idle") return "\u{f0772}";  // nf-md-circle-slice-8
        if (status === "dormant") return "\u25cb";  // hollow circle
        return "\u00b7";                            // unknown
    }

    function statusColor(status) {
        if (status === "active") return popup.colors.green;
        if (status === "idle") return popup.colors.foregroundAlt;
        if (status === "dormant") return popup.colors.alert;
        return popup.colors.foregroundAlt;
    }

    // Empty for an unknown age, which is what an agent with no session file
    // reports.
    function shortAge(seconds) {
        if (isNaN(seconds) || seconds < 0) return "";
        if (seconds < 60) return "now";
        if (seconds < 3600) return Math.floor(seconds / 60) + "m";
        if (seconds < 86400) return Math.floor(seconds / 3600) + "h";
        return Math.floor(seconds / 86400) + "d";
    }
}
