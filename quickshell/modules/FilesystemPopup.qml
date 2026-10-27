// File: quickshell/modules/FilesystemPopup.qml
//
// Clicking the filesystem module opens this: every real mounted filesystem,
// not just the root the bar has room for.
//
// The list comes from df rather than from a mount table parsed in QML, because
// df is already the thing the module's own script uses, so the two always
// agree about what "used" means.
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    property var filesystems: []

    title: "Disk"
    labelWidth: 64
    popupWidth: 300

    rows: filesystems

    Process {
        id: df

        stdout: StdioCollector {
            onStreamFinished: popup.parse(text)
        }
    }

    Timer {
        interval: 10000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: df.exec([
            "df", "-H", "--output=target,size,used,avail,pcent",
            "-x", "tmpfs", "-x", "devtmpfs", "-x", "efivarfs"
        ])
    }

    // Mounted on        Size  Used  Avail  Use%
    // /                 2.0T  452G  1.5T   25%
    function parse(text) {
        var out = [];
        var lines = text.split("\n");
        for (var i = 1; i < lines.length; i++) {
            var f = lines[i].trim().split(/\s+/);
            if (f.length < 5) continue;
            out.push({ label: f[0], value: f[2] + " of " + f[1] + "  (" + f[4] + ")" });
        }
        popup.filesystems = out;
    }
}
