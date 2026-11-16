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
//     filled  ●  active    a run is in progress right now
//     bull    ◎  idle      waiting for input, session touched within a day
//     hollow  ○  dormant   waiting for input, untouched for longer
//     middle  ·  unknown   running, but no session file to judge by
//
// The colour ladder is shared with ZellijSessionsPopup: accent for a run in
// progress, the bar's own foreground for agents that are simply there, dim for
// nothing to report, and the dark alert colour for a stale or exited session.
//
// The idle glyph is the Unicode bullseye rather than an icon-font
// circle-slice, for the same reason as in ZellijSessionsPopup.qml: at 13
// logical px (26 physical px on both panels) the slice glyphs rasterise into a
// thin arc that reads as a smudge, while a ring with a centre dot stays
// legible and keeps the circle family of the other three.
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

    // True when the last run exited non-zero. An empty stdout from a failed run
    // parses to an empty list, which would render as "none running" -- a claim
    // about the machine rather than about the read. Kept separate so the two can
    // be told apart.
    property bool failed: false

    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/pi-agents"

    title: "Pi Agents"
    // Room for the glyph plus a project directory name, which is the long half
    // of the left column.
    labelWidth: 150
    popupWidth: 560

    rows: popup.failed
          ? [{ label: "Agents", value: "could not read", color: popup.colors.alert }]
          : popup.agents === null
            ? [{ label: "Agents", value: "\u2026" }]
            : popup.agents.length > 0
              ? popup.agents
              : [{ label: "Agents", value: "none running" }]

    Process {
        id: lister

        stdout: StdioCollector {
            onStreamFinished: popup.parse(text)
        }

        onExited: function (code) {
            popup.failed = code !== 0;
        }
    }

    // Polled only while the popup is open. Opening restarts the timer from the
    // top, so the list is always fresh on the first paint.
    //
    // 15s rather than 5s: one run costs about 0.34s of CPU and spawns 85
    // processes, since it reads a session file per agent. At 5s that is 6.8% of
    // a core for as long as the popup is left open; at 15s it is 2.3%. Nothing
    // in the list changes faster than that.
    // Whether the current run produced an answer. A script that is missing or
    // not executable fails inside exec, and then neither the stdout collector
    // nor `exited` ever fires -- the popup would sit on "starting" forever. The
    // watchdog below turns that silence into the same "could not read" row a
    // non-zero exit produces.
    property bool answered: false

    Timer {
        interval: 15000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: {
            popup.answered = false;
            watchdog.restart();
            lister.exec([popup.scriptPath]);
        }
    }

    Timer {
        id: watchdog

        interval: 5000

        onTriggered: {
            if (!popup.answered) popup.failed = true;
        }
    }

    // One line per agent: status, project, name, idle seconds, source.
    function parse(text) {
        popup.answered = true;

        var out = [];
        var lines = text.split("\n");

        for (var i = 0; i < lines.length; i++) {
            if (lines[i].trim() === "") continue;

            var field = lines[i].split("\t");
            if (field.length < 6) continue;

            var status = field[0];
            var name = field[2];
            var age = popup.shortAge(parseInt(field[3], 10));
            var pid = field[5];

            // An agent with no session file has no name to show, and the script
            // falls back to the project for it, which reads as the same word
            // twice. Say what is actually true instead, and give the pid so the
            // process can be found: without a session there is nothing else to
            // identify it by.
            var value = status === "unknown"
                        ? "no session file  pid " + pid
                        : (age === "" ? name : name + "  " + age);

            out.push({
                // The glyph carries the state, so the colour is reinforcement
                // rather than the only signal.
                label: popup.statusGlyph(status) + " " + field[1],
                value: value,
                color: popup.statusColor(status)
            });
        }

        popup.commit(out);
    }

    // Replacing the list tears down and rebuilds every row of the Repeater, so
    // only replace it when the rows actually differ. A poll that returns the
    // same answer -- the usual case, every 15s while the popup is open -- then
    // costs nothing on screen. Only the label and value are compared because
    // the colour is a function of them: a row changes colour only when its
    // status glyph or its state text changes with it.
    function commit(out) {
        var old = popup.agents;

        if (old !== null && old.length === out.length) {
            var same = true;

            for (var i = 0; i < out.length; i++) {
                if (old[i].label !== out[i].label || old[i].value !== out[i].value) {
                    same = false;
                    break;
                }
            }

            if (same) return;
        }

        popup.agents = out;
    }

    function statusGlyph(status) {
        if (status === "active") return "\u25cf";   // filled circle
        if (status === "idle") return "\u25ce";    // bullseye
        if (status === "dormant") return "\u25cb";  // hollow circle
        return "\u00b7";                            // unknown
    }

    // The same colour ladder as ZellijSessionsPopup.rowColor, so one state looks
    // the same in both popups and in the bar itself:
    //
    //     secondary      a run is in progress right now
    //     foreground     agents are there, none of them is running -- the same
    //                    #e0e0e0 the bar uses for every module's text
    //     foregroundAlt  nothing to report: no session file to judge by
    //     alert          present but stale: a session untouched for longer
    function statusColor(status) {
        if (status === "active") return popup.colors.secondary;
        if (status === "idle") return popup.colors.foreground;
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
