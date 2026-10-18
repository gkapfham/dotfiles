// File: quickshell/modules/WorkspacePopup.qml
//
// Right-clicking a workspace label opens this: the windows living on that
// workspace, which is the one thing a number on the bar cannot show.
//
// Quickshell 0.3.0's Quickshell.I3 service exposes workspaces and monitors but
// no window list, so the windows come from i3's own tree over its IPC socket
// (`i3-msg -t get_tree`) -- the same source polybar's i3 module used. The tree
// is walked here rather than filtered by an external tool, so this needs
// nothing that i3 does not already provide.
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    // Which workspace to describe. Bar.qml sets this when a label is
    // right-clicked, so it cannot be a required property: required properties
    // have to be initialized where the popup is created, and this one changes
    // every time a different label is clicked.
    property string workspaceName: ""

    // One { app, title } per window on that workspace.
    property var windows: []

    title: "Workspace " + popup.workspaceName
    // Room for a window title beside the app name, which is the long half of
    // the pair.
    labelWidth: 96
    popupWidth: 460

    rows: popup.windows.length > 0
          ? popup.windows.map(function (w) {
                return { label: w.app, value: w.title };
            })
          : [{ label: "Windows", value: "none" }]

    Process {
        id: treeReader

        stdout: StdioCollector {
            onStreamFinished: popup.readTree(text)
        }
    }

    // Polled only while the popup is open: it spawns a process each time, and
    // a closed popup has nothing to show. Opening the popup restarts the timer
    // from the top, so the list is always fresh on the first paint.
    Timer {
        interval: 2000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: treeReader.exec(["i3-msg", "-t", "get_tree"])
    }

    // i3's tree is nested: outputs contain workspaces, workspaces contain
    // windows, and windows contain splits. The workspace name is carried down
    // the walk rather than looked up per window, because a leaf does not record
    // which workspace it is on.
    function readTree(json) {
        var root;
        try {
            root = JSON.parse(json);
        } catch (e) {
            // Leave the previous list on screen rather than blanking the popup
            // if the read came back truncated.
            return;
        }

        var found = [];
        popup.collect(root, null, found);
        popup.windows = found;
    }

    function collect(node, workspace, out) {
        if (!node) return;

        var ws = node.type === "workspace" ? node.name : workspace;

        // `window` is i3's window id and is null on anything that is only a
        // container. The bar's own windows belong to no workspace at all, so
        // the ws === workspaceName test also keeps them out of the list.
        if (node.window !== null && node.window !== undefined && ws === popup.workspaceName) {
            var props = node.window_properties || {};
            // X11 fills window_properties.class; Wayland clients report
            // app_id instead.
            out.push({
                app: popup.appName(props["class"] || node.app_id || "?"),
                title: node.name || ""
            });
        }

        var kids = (node.nodes || []).concat(node.floating_nodes || []);
        for (var i = 0; i < kids.length; i++) popup.collect(kids[i], ws, out);
    }

    // X11 reports WM_CLASS, which for anything packaged under a reverse-DNS
    // name reads "com.mitchellh.ghostty" where only the last part is worth
    // showing. Classes with no dot ("firefox") are left alone.
    function appName(cls) {
        var dot = cls.lastIndexOf(".");
        return dot >= 0 && dot < cls.length - 1 ? cls.slice(dot + 1) : cls;
    }
}
