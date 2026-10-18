// File: quickshell/modules/MemoryPopup.qml
//
// Clicking the memory module opens this: the breakdown the bar's one figure
// hides. /proc/meminfo supplies the totals, and the top rows come from ps so
// it is obvious what is actually holding the memory.
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    property real total: 0
    property real free: 0
    property real available: 0
    property real cached: 0
    property real buffers: 0
    property real shared: 0
    property real swapTotal: 0
    property real swapFree: 0
    property var topProcesses: []

    title: "Memory"
    // A wide label column so process names fit; see the row comments below.
    labelWidth: 120
    popupWidth: 380

    rows: {
        // Used is total minus available, which is how free(1) defines it and
        // therefore what the bar's own memory script prints -- the two would
        // otherwise disagree by several GiB. Cached is Cached plus
        // SReclaimable, again matching free's buff/cache column, so the rows
        // here can be read against `free` directly.
        var used = popup.total - popup.available;
        var list = [
            { label: "Used", value: popup.gib(used) + " / " + popup.gib(popup.total)
                              + "  (" + popup.percent(used) + ")" },
            { label: "Available", value: popup.gib(popup.available) },
            { label: "Cached", value: popup.gib(popup.cached) },
            { label: "Buffers", value: popup.gib(popup.buffers) },
            { label: "Shared", value: popup.gib(popup.shared) },
            { label: "Swap", value: popup.swapTotal > 0
                                    ? popup.gib(popup.swapTotal - popup.swapFree)
                                      + " / " + popup.gib(popup.swapTotal)
                                    : "none" }
        ];

        if (popup.topProcesses.length > 0) {
            list.push({ label: "Top processes", value: "" });
            for (var i = 0; i < popup.topProcesses.length; i++) {
                list.push(popup.topProcesses[i]);
            }
        }
        return list;
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onTextChanged: popup.parseMeminfo()
    }

    Process {
        id: ps

        stdout: StdioCollector {
            onStreamFinished: popup.parsePs(text)
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            meminfo.reload();
            ps.exec(["ps", "-eo", "rss=,comm=", "--sort=-rss"]);
        }
    }

    function parseMeminfo() {
        var text = meminfo.text();

        function kb(key) {
            var match = text.match(new RegExp("^" + key + ":\\s+(\\d+)", "m"));
            return match ? parseInt(match[1], 10) : 0;
        }

        popup.total = kb("MemTotal");
        popup.free = kb("MemFree");
        popup.available = kb("MemAvailable");
        // Reclaimable slab counts as cache, the same way free counts it.
        popup.cached = kb("Cached") + kb("SReclaimable");
        popup.buffers = kb("Buffers");
        popup.shared = kb("Shmem");
        popup.swapTotal = kb("SwapTotal");
        popup.swapFree = kb("SwapFree");
    }

    function parsePs(text) {
        var out = [];
        var lines = text.split("\n");

        for (var i = 0; i < lines.length && out.length < 4; i++) {
            var fields = lines[i].trim().split(/\s+/);
            if (fields.length < 2) continue;

            var kib = parseInt(fields[0], 10);
            if (isNaN(kib) || kib <= 0) continue;

            out.push({
                label: fields.slice(1).join(" "),
                value: (kib / 1024).toFixed(0) + " MiB"
            });
        }

        popup.topProcesses = out;
    }

    function gib(kib) {
        return (kib / 1048576).toFixed(1) + " GiB";
    }

    function percent(used) {
        return popup.total > 0 ? Math.round(100 * used / popup.total) + "%" : "\u2014";
    }
}
