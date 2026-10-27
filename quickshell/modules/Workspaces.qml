// File: quickshell/modules/Workspaces.qml
//
// The polybar [module/i3] replacement: one label per workspace, plus the
// binding-mode indicator.
//
// polybar got this over the i3 IPC socket; quickshell's Quickshell.I3 service
// speaks the same protocol, so the rofi workspace integration is untouched --
// it drives i3 with i3-msg, and the names, urgency hints and binding modes it
// sets show up here exactly as they did in polybar.
//
// NOTE: the parent sets this row's height explicitly (see Bar.qml). The
// children then take `height: parent.height`; writing `height: root.height`
// here instead would be a binding loop on this row's own height, which
// collapses the whole block to zero.
import Quickshell
import Quickshell.I3
import QtQuick

Row {
    id: root

    required property QtObject colors
    required property var screen
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // What clicking the icon at the far left of the bar runs. The bar fills
    // this in with the same omni launcher Control+Alt+p runs; left empty, the
    // icon is inert.
    property var omniCommand: []

    // Right-clicking a label asks the bar to open a popup listing that
    // workspace's windows. The x travels with the name because the popup has
    // to anchor under the label that was clicked, and only this row knows
    // where its labels ended up.
    signal workspaceMenuRequested(string name, real x)

    // polybar's workspace labels sit flush against each other; the padding
    // inside each label is what separates them.
    spacing: 0

    // The i3 binding mode ("resize", "power", ...), "default" when idle.
    property string mode: "default"

    Connections {
        target: I3

        function onRawEvent(event) {
            if (event.type === "binding") {
                root.mode = event.data.change;
            }
        }
    }

    // polybar pin-workspaces = true: only show the workspaces that live on
    // this bar's monitor.
    //
    // `I3.monitors.values` is read on purpose: I3.monitorFor() is an ordinary
    // function call and QML cannot see through it, so without reading the
    // monitor list here this binding would run once before the IPC socket has
    // answered and stay null forever.
    readonly property var monitor: {
        var monitors = I3.monitors.values;
        return monitors.length > 0 ? I3.monitorFor(root.screen) : null;
    }

    // Mouse interaction, matching what polybar's [module/i3] did with
    // enable-click and wrapping-scroll: clicking a label switches to that
    // workspace, and scrolling anywhere in the row steps to the previous or
    // next one.
    //
    // The step is computed from this monitor's own workspace list rather than
    // by dispatching i3's `workspace next`. That command walks i3's global
    // list, so on a two-monitor setup it happily jumps to a workspace on the
    // other screen. polybar's focus_direction() collected the workspaces for
    // the bar's monitor and stepped inside that list, which is what this does.
    // polybar/config.ini sets wrapping-scroll = true, so it wraps at the ends.
    function stepWorkspace(delta) {
        if (delta === 0) return;

        var list = root.myWorkspaces;
        if (list.length === 0) return;

        // Anchor on the workspace this monitor is showing. `active` is i3's
        // "visible on its output"; `focused` covers the focused monitor.
        var current = -1;
        for (var i = 0; i < list.length; i++) {
            if (list[i].focused || list[i].active) { current = i; break; }
        }
        if (current < 0) return;

        var target = current + (delta > 0 ? 1 : -1);
        if (target < 0) target = list.length - 1;
        if (target >= list.length) target = 0;

        I3.dispatch(root.focusCommand(list[target].name));
    }

    // Workspace names can contain spaces (the rofi rename prompt allows them),
    // so the name is always quoted for i3's command parser.
    function focusCommand(name) {
        return 'workspace "' + name.replace(/"/g, '\\"') + '"';
    }

    readonly property var myWorkspaces: {
        var mon = monitor;
        if (!mon) return [];
        // polybar index-sort = true: order by workspace number.
        return I3.workspaces.values
            .filter(function (w) { return w.monitor && w.monitor.name === mon.name; })
            .sort(function (a, b) { return (a.number || 0) - (b.number || 0); });
    }

    // polybar format-prefix = "  "
    // (space, grid icon, two spaces: the leading gap keeps the icon clear of
    // the rounded corner of the laptop panel)
    Text {
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        text: " \uf009  "
        color: root.colors.foreground
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
            onClicked: {
                if (root.omniCommand.length > 0) Quickshell.execDetached(root.omniCommand);
            }
            onWheel: function (wheel) { root.stepWorkspace(wheel.angleDelta.y); }
        }
    }

    Repeater {
        model: root.myWorkspaces

        delegate: Item {
            required property var modelData

            width: pill.implicitWidth
            height: parent.height

            Rectangle {
                id: pill

                anchors.verticalCenter: parent.verticalCenter

                // polybar label-*-padding = 1, which works out to 16px of
                // horizontal padding at this font size (8 logical).
                implicitWidth: label.implicitWidth + 16
                height: 18

                // Focused = the workspace on the focused monitor;
                // Visible = active on a monitor that is not focused;
                // Urgent  = a window in it set the urgency hint.
                color: modelData.urgent
                       ? root.colors.secondary
                       : (modelData.focused || modelData.active)
                         ? root.colors.primary
                         : "transparent"

                Text {
                    id: label

                    anchors.centerIn: parent
                    text: modelData.name
                    color: modelData.urgent
                           ? "#1c1c1c"
                           : modelData.focused
                             ? root.colors.foreground
                             : modelData.active
                               ? root.colors.foregroundAlt
                               : root.colors.foreground
                    // CurveRendering is grayscale antialiasing, which is what polybar's
                    // Xft rendering produced. Qt's default adds colour fringes that make
                    // the text look a size thinner than polybar's.
                    renderType: Text.CurveRendering
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.bold: root.fontBold
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    // Left click switches to the workspace, right click asks
                    // for its window list. Adding the right button here does
                    // not change what the left button does, and it keeps the
                    // right click off the bar's backdrop, which would
                    // otherwise read it as a dismiss.
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: function (mouse) {
                        if (mouse.button === Qt.RightButton) {
                            // Called on click, not used as a binding, so this
                            // function call is safe here; see the note in
                            // InfoPopup.qml for why a binding would not be.
                            root.workspaceMenuRequested(modelData.name, mapToItem(null, 0, 0).x);
                        } else {
                            I3.dispatch(root.focusCommand(modelData.name));
                        }
                    }
                    onWheel: function (wheel) { root.stepWorkspace(wheel.angleDelta.y); }
                }
            }
        }
    }

    // polybar label-mode: the binding mode pill, background primary.
    Item {
        width: modePill.implicitWidth + 10
        height: parent.height
        visible: root.mode !== "default"

        Rectangle {
            id: modePill

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: modeText.implicitWidth + 10
            height: 18
            color: root.colors.primary

            Text {
                id: modeText

                anchors.centerIn: parent
                text: root.mode
                color: root.colors.foreground
                // CurveRendering is grayscale antialiasing, which is what polybar's
                // Xft rendering produced. Qt's default adds colour fringes that make
                // the text look a size thinner than polybar's.
                renderType: Text.CurveRendering
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.bold: root.fontBold
            }
        }
    }
}
