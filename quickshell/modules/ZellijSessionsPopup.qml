// File: quickshell/modules/ZellijSessionsPopup.qml
//
// Opened by clicking the tab glyph in the bar: every zellij session on this
// machine, what the pi coding agents inside it are doing, and whether a client
// is attached.
//
// The data comes from quickshell/scripts/zellij-sessions, which pairs `zellij ls`
// with two things zellij does not report: the pi processes living in each
// session (found by walking each agent's parent chain to the zellij server that
// owns its pane) and whether a client is attached to it (read from the session
// sockets in /proc/net/unix). See the script for both.
//
// The status glyphs, brightest first:
//
//     filled  ●  working   an agent in the session is mid-run right now
//     bull    ◎  agents    agents are there, none of them is running a turn
//     dotted  ◌  empty     a live session with no agents
//     hollow  ○  exited    kept by zellij, resumable with `zellij attach`
//
// The idle glyph is the Unicode bullseye, not an icon-font circle-slice: at
// this size (13 logical px, which is 26 physical px on both panels) the
// nf-md circle-slice glyphs rasterise into a thin arc that reads as a smudge,
// while the bullseye stays in the circle family of the other three and still
// resolves into a ring with a centre dot.
//
// The colour is the same signal as the glyph, so a row can be found at a
// glance: accent for a run in progress, the bar's own foreground for agents that
// are idle, dim for an empty session, and the dark alert colour for an exited
// one. The ladder is shared with PiAgentsPopup, so the same state is the same
// colour in both lists. The script sorts the rows busiest first, so the top of
// the popup is the session with the most work in it.
//
// There is deliberately no "(current)" marker. `zellij ls` decides that from
// the ZELLIJ_SESSION_NAME in its own environment, not from any attachment
// state, and the bar inherits that variable once at launch -- so the popup used
// to highlight whichever session the bar had first been started from, forever.
// "attached" in the value column is a real reading of the session's sockets.
import Quickshell
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    // null until the first read finishes, so the popup does not claim there are
    // no sessions while the script is still starting.
    property var sessions: null

    // True when the last run exited non-zero. An empty stdout from a failed run
    // parses to an empty list, which would render as "none" -- a claim about
    // zellij rather than about the read. Kept separate so the two can be told
    // apart.
    property bool failed: false

    readonly property string scriptPath: Quickshell.env("HOME")
                                         + "/.config/quickshell/scripts/zellij-sessions"

    title: "Zellij Sessions"
    // Room for a glyph plus a session name like "Senior-Comprehensive-Project",
    // and a value column wide enough for "attached · 3 agents · 1 working
    // 8days": the widest value the script can produce.
    labelWidth: 210
    popupWidth: 580

    rows: popup.failed
          ? [{ label: "Sessions", value: "could not read", color: popup.colors.alert }]
          : popup.sessions === null
            ? [{ label: "Sessions", value: "\u2026" }]
            : popup.sessions.length > 0
              ? popup.sessions
              : [{ label: "Sessions", value: "none" }]

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
    // 10s, not 15s: the script now costs ~130ms per run instead of ~510ms (the
    // parent-chain walk reads /proc through bash builtins rather than forking
    // tr and awk twice per hop), so this is both fresher and cheaper than the
    // interval it replaces.
    // Whether the current run produced an answer. A script that is missing or
    // not executable fails inside exec, and then neither the stdout collector
    // nor `exited` ever fires -- the popup would sit on "starting" forever. The
    // watchdog below turns that silence into the same "could not read" row a
    // non-zero exit produces.
    property bool answered: false

    Timer {
        interval: 10000
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

    // One line per session: working, agents, attached, live, session, age.
    function parse(text) {
        popup.answered = true;

        var out = [];
        var lines = text.split("\n");

        for (var i = 0; i < lines.length; i++) {
            if (lines[i].trim() === "") continue;

            var field = lines[i].split("\t");
            if (field.length < 6) continue;

            var working = parseInt(field[0], 10);
            var agents = parseInt(field[1], 10);
            var attached = field[2] === "1";
            var live = field[3] === "1";
            var session = field[4];
            var age = field[5];

            if (isNaN(working)) working = 0;
            if (isNaN(agents)) agents = 0;

            out.push({
                label: popup.glyph(working, agents, live) + " " + session,
                value: popup.rowValue(working, agents, attached, live, age),
                color: popup.rowColor(working, agents, live)
            });
        }

        popup.commit(out);
    }

    // Replacing the list tears down and rebuilds every row of the Repeater, so
    // only replace it when the rows actually differ. A poll that returns the
    // same answer -- the usual case, every 10s while the popup is open -- then
    // costs nothing on screen. Only the label and value are compared because
    // the colour is a function of them: a row changes colour only when its
    // status glyph or its agent counts change with it.
    function commit(out) {
        var old = popup.sessions;

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

        popup.sessions = out;
    }

    function glyph(working, agents, live) {
        if (!live) return "\u25cb";          // hollow circle: exited
        if (working > 0) return "\u25cf";    // filled circle: a run in progress
        if (agents > 0) return "\u25ce";    // bullseye: agents, none working
        return "\u25cc";                     // dotted circle: no agents
    }

    // The same colour ladder as PiAgentsPopup.statusColor, so one state looks the
    // same in both popups and in the bar itself:
    //
    //     secondary      an agent in the session is mid-run right now
    //     foreground     agents are there, none of them is running -- the same
    //                    #e0e0e0 the bar uses for every module's text
    //     foregroundAlt  nothing to report: a live session with no agents
    //     alert          present but stale: a session zellij kept for resuming
    function rowColor(working, agents, live) {
        if (!live) return popup.colors.alert;
        if (working > 0) return popup.colors.secondary;
        if (agents > 0) return popup.colors.foreground;
        return popup.colors.foregroundAlt;
    }

    // "attached", then what the agents are doing, then a coarse age.
    //
    // The age is the first word of zellij's "Created ... ago" string: the whole
    // string runs to 18 characters ("8days 18h 59m 52s") and would push the
    // agent counts out of the value column, which is the part worth reading.
    // An exited session keeps the coarse age because that is the only thing
    // worth saying about it.
    function rowValue(working, agents, attached, live, age) {
        var coarseAge = age.split(" ")[0];

        if (!live) return "exited  " + coarseAge;

        var text = attached ? "attached \u00b7 " : "";

        if (agents === 0) {
            text += "no agents";
        } else {
            text += agents === 1 ? "1 agent" : agents + " agents";
            if (working > 0) text += " \u00b7 " + working + " working";
        }

        return text + "  " + coarseAge;
    }
}
