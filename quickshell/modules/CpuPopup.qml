// File: quickshell/modules/CpuPopup.qml
//
// Clicking the CPU module opens this: what the bar's one percentage cannot
// show. Load averages and the process count come from /proc/loadavg, the
// clock from the cpufreq sysfs nodes, and the model and core count from
// /proc/cpuinfo, read once at startup since neither changes.
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    property real lastTotal: 0
    property real lastIdle: 0
    property int percent: 0
    property string load: "\u2014"
    property string processes: "\u2014"
    property string frequency: "\u2014"
    property string model: "\u2014"
    property int cores: 0

    title: "CPU"
    // Wider than the other popups so the model name has somewhere to go.
    labelWidth: 92
    popupWidth: 380

    rows: [
        { label: "Model", value: popup.model },
        { label: "Cores", value: popup.cores > 0 ? String(popup.cores) : "\u2014" },
        { label: "Usage", value: popup.percent + "%" },
        { label: "Load", value: popup.load },
        { label: "Processes", value: popup.processes },
        { label: "Frequency", value: popup.frequency }
    ].concat(popup.topProcs)

    // The three busiest processes, appended to the rows above. Deliberately taken
    // from top's second sample rather than from ps: ps reports %CPU as a lifetime
    // average (cputime / elapsed), which for an agent that has been idle for days
    // reads near zero while it is in fact busy right now. Measured on this
    // machine, ps put the busiest process at 2.9% where top showed 12%.
    //
    // The first top sample is always meaningless, so -n2 with a short delay is
    // the smallest invocation that gives a real reading.
    property var topProcs: []

    Process {
        id: procReader

        stdout: StdioCollector {
            onStreamFinished: popup.parseTop(text)
        }
    }

    // Slower than the other readings on purpose: the pipeline below runs top
    // twice with a delay, so it costs about half a second each time it runs.
    Timer {
        interval: 6000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: procReader.exec([
            "bash", "-c",
            "top -bn2 -d 0.4 -o %CPU | awk '/^top -/{n++} n==2' | tail -n +8 | head -3"
        ])
    }

    function parseTop(text) {
        var out = [];
        var lines = text.split("\n");

        for (var i = 0; i < lines.length; i++) {
            var field = lines[i].trim().split(/\s+/);
            // pid user pri ni virt res shr S %cpu %mem time+ command...
            if (field.length < 12) continue;

            var cpu = parseFloat(field[8]);
            if (isNaN(cpu)) continue;

            out.push({
                // The command is the dim label, the percentage the bright value,
                // matching how every other row in these popups reads.
                label: field.slice(11).join(" "),
                value: cpu.toFixed(1) + "%"
            });

            if (out.length === 3) break;
        }

        if (out.length > 0) popup.topProcs = out;
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onTextChanged: popup.sampleUsage()
    }

    FileView {
        id: loadavg
        path: "/proc/loadavg"
        onTextChanged: {
            var f = loadavg.text().trim().split(/\s+/);
            if (f.length >= 4) {
                popup.load = f[0] + " " + f[1] + " " + f[2];
                popup.processes = f[3];
            }
        }
    }

    FileView {
        id: freq
        path: "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
        onTextChanged: {
            var khz = parseInt(freq.text().trim(), 10);
            if (!isNaN(khz)) popup.frequency = (khz / 1e6).toFixed(2) + " GHz";
        }
    }

    FileView {
        id: cpuinfo
        path: "/proc/cpuinfo"
        onTextChanged: {
            var text = cpuinfo.text();
            var m = text.match(/model name\s*:\s*(.+)/);
            if (m) popup.model = m[1].trim();
            var count = 0;
            var re = /^processor\s*:/gm;
            while (re.exec(text) !== null) count += 1;
            popup.cores = count;
        }
    }

    // Sampled continuously rather than only while open, so the first open
    // already has a previous reading to difference against.
    Timer {
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            stat.reload();
            loadavg.reload();
            freq.reload();
        }
    }

    Component.onCompleted: cpuinfo.reload()

    // "cpu  user nice system idle iowait irq softirq steal guest guest_nice"
    function sampleUsage() {
        var fields = stat.text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
        if (fields.length < 4) return;

        var idle = fields[3] + (fields[4] || 0);
        var total = 0;
        for (var i = 0; i < fields.length; i++) total += fields[i];

        if (popup.lastTotal > 0 && total > popup.lastTotal) {
            var dTotal = total - popup.lastTotal;
            var dIdle = idle - popup.lastIdle;
            popup.percent = Math.round(100 * (dTotal - dIdle) / dTotal);
        }

        popup.lastTotal = total;
        popup.lastIdle = idle;
    }
}
