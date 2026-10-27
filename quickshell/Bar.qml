// File: quickshell/Bar.qml
//
// One bar, on one monitor. shell.qml creates an instance per screen.
//
// This is a port of polybar's [bar/mybar] from polybar/config.ini: the same
// 60px height, the same fonts, the same colors and the same modules in the
// same order. The one deliberate difference is the center block: polybar had
// no way to let a region shrink, so a long label (a discharging battery is
// the usual culprit) pushed the clock off the screen. Here the center block
// drops to its short forms and then gives up its least important modules,
// while the workspaces on the left and the clock on the right are never
// clipped.
import Quickshell
import QtQuick
import "modules"

PanelWindow {
    id: bar

    // Variants (shell.qml) hands each instance the screen it belongs to.
    required property var modelData
    screen: modelData

    // The shared palette from Colors.qml.
    required property QtObject colors

    // ---- geometry, from [bar/mybar] -----------------------------------
    //
    // polybar drew a 60px tall bar. Quickshell works in logical coordinates
    // and this panel is 2x, so 30 logical == 60 physical.
    implicitHeight: 30
    anchors {
        top: true
        left: true
        right: true
    }
    color: colors.background

    // polybar let the window manager derive the strut from the window.
    // Quickshell 0.3.0 writes _NET_WM_STRUT_PARTIAL in physical pixels but
    // takes the value from the logical implicit height, which would reserve
    // only half the bar on a 2x panel and let windows slide underneath.
    // Reserve the real pixel height instead.
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: implicitHeight * screen.devicePixelRatio

    // ---- typography, from [bar/mybar] ----------------------------------
    // polybar: font-0 = "Maple Mono NF:size=20:weight=bold;5"
    readonly property string fontFamily: "Maple Mono NF"
    readonly property int fontSize: 13
    readonly property bool fontBold: true

    // polybar: module-margin-left = 12px, module-margin-right = 8px, so
    // neighbouring modules are 20 physical px (10 logical) apart.
    readonly property int moduleSpacing: 10

    // Breathing room between the left, center and right blocks so that they
    // never touch.
    readonly property int groupGap: 6

    // The remaining custom/script modules (fan, memory, filesystem) are
    // polybar's own scripts, unchanged, so those still print byte-for-byte
    // what polybar printed. The battery moved to the native UPower service;
    // see modules/Battery.qml for why.
    readonly property string scriptDir: Quickshell.env("HOME") + "/.config/polybar/scripts"

    // What Control+Alt+p runs: the tabbed omni launcher (ROFI_TABS=1 is what
    // the i3 binding sets). Clicking the icon at the far left of the bar opens
    // the same launcher, so the mouse and the keyboard land in the same place.
    readonly property var omniLauncher: [
        "env",
        "ROFI_TABS=1",
        Quickshell.env("HOME") + "/.config/i3/scripts/i3-run-rofi-full-path.sh"
    ]

    // ====================================================================
    // Left block: the i3 workspaces
    // ====================================================================

    // A click on bare bar space dismisses any open popup.
    //
    // Quickshell 0.3.0's PopupWindow.grabFocus does not dismiss on an outside
    // click under X11 -- there is no X11 focus-grab implementation, so the
    // popup never learns that it lost the click -- so the bar does it itself.
    // This is declared first, which puts it behind every module; modules with
    // their own MouseArea keep their clicks and the rest fall through here.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: bar.closePopups()
    }

    // Opening one popup closes the others, so two can never be open at once.
    function closePopups() {
        calendar.visible = false;
        batteryPopup.visible = false;
        cpuPopup.visible = false;
        filesystemPopup.visible = false;
        memoryPopup.visible = false;
        wifiPopup.visible = false;
        workspacePopup.visible = false;
        agentsPopup.visible = false;
    }

    // The workspace popup cannot use togglePopup above, because unlike the
    // others it is shared by every workspace label. togglePopup compares
    // visibility only, so right-clicking a second label while the popup was
    // open would read as "already open" and close it, when what was asked for
    // was the other workspace's list. Comparing the workspace as well keeps
    // the three cases apart: same label closes, a different label switches,
    // and no popup at all opens.
    function toggleWorkspacePopup(name, x) {
        var sameWorkspace = workspacePopup.visible && workspacePopup.workspaceName === name;

        closePopups();
        workspacePopup.workspaceName = name;
        workspacePopup.anchorX = x;
        workspacePopup.visible = !sameWorkspace;
    }

    // Every module's click goes through here, so all five regions behave the
    // same way: click one and its popup opens, click it again and it closes,
    // click a different one and that replaces it. Without this, a region that
    // always opened would close and immediately reopen on a second click,
    // which reads as a flicker rather than a toggle.
    function togglePopup(popup) {
        var wasOpen = popup.visible;
        closePopups();
        popup.visible = !wasOpen;
    }

    Workspaces {
        id: leftGroup

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        // Set explicitly: the workspaces row sizes its children from its own
        // height, so it must not be left to compute that height from them.
        height: bar.height

        colors: bar.colors
        screen: bar.screen
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
        omniCommand: bar.omniLauncher

        onWorkspaceMenuRequested: function (name, x) {
            bar.toggleWorkspacePopup(name, x);
        }
    }

    // ====================================================================
    // Right block: backlight, volume, date
    //
    // This block is anchored to the right edge and is never allowed to shrink
    // or hide, so the date and time stay readable no matter what the center
    // block does.
    // ====================================================================
    Row {
        id: rightGroup

        anchors {
            right: parent.right
            rightMargin: 4
            verticalCenter: parent.verticalCenter
        }

        height: bar.height
        spacing: bar.moduleSpacing

        Backlight {
            height: bar.height
            interval: 15
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
        }

        Volume {
            height: bar.height
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
        }

        // Not a polybar module: polybar had no bluetooth indicator at all.
        // Sits after the volume, before the date.
        Bluetooth {
            id: bluetooth
            height: bar.height
            color: bar.colors.foreground
            dimColor: bar.colors.foregroundAlt
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
        }

        // Not a polybar module either: a bell for dunst's notification
        // history, before the date.
        Notifications {
            id: notifications
            height: bar.height
            color: bar.colors.foreground
            dimColor: bar.colors.foregroundAlt
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
        }

        // Not a polybar module either: a robot for the pi coding agents
        // running on this machine, after the notification bell.
        PiAgents {
            id: agents
            height: bar.height
            color: bar.colors.foreground
            dimColor: bar.colors.foregroundAlt
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(agentsPopup)
            }
        }

        // polybar [module/date]: format-prefix " ",
        // date = "<clock icon> %b %d", time = "%H:%M "
        //
        // The trailing space is polybar's, not a mistake: it is what keeps the
        // clock clear of the right edge of the screen.
        //
        // Clicking it opens the calendar below (modules/CalendarPopup.qml),
        // which is something polybar had no way to do at all.
        Text {
            id: clockLabel

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }

            height: bar.height
            verticalAlignment: Text.AlignVCenter
            text: " \uf455 " + Qt.formatDateTime(clock.date, "MMM dd")
                  + " " + Qt.formatDateTime(clock.date, "HH:mm") + " "
            color: bar.colors.foreground
            // CurveRendering is grayscale antialiasing, which is what polybar's
            // Xft rendering produced. Qt's default adds colour fringes that make
            // the text look a size thinner than polybar's.
            renderType: Text.CurveRendering
            font.family: bar.fontFamily
            font.pixelSize: bar.fontSize
            font.bold: bar.fontBold

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(calendar)
            }
        }
    }

    // The calendar is a child of this window because it anchors to it.
    CalendarPopup {
        id: calendar
        anchorWindow: bar
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // Opened by clicking the robot. A child of this window because it anchors
    // to it.
    PiAgentsPopup {
        id: agentsPopup
        anchorWindow: bar
        anchorX: agents.x + rightGroup.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // Opened by right-clicking a workspace label. anchorX is overwritten on
    // every click; a required property still has to be initialized here for
    // the popup to be created at all.
    WorkspacePopup {
        id: workspacePopup
        anchorWindow: bar
        anchorX: 0
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // The volume/brightness OSD. It watches those values itself and shows
    // itself, so it is deliberately not part of the popup toggle group above:
    // it must not be closed by a click, only by its own timer.
    OsdPopup {
        id: osd
        barWindow: bar
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // Opened by clicking the battery. Its x is written out from the two
    // reactive positions that make it up; see the note in InfoPopup.qml.
    BatteryPopup {
        id: batteryPopup
        anchorWindow: bar
        anchorX: battery.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    CpuPopup {
        id: cpuPopup
        anchorWindow: bar
        anchorX: cpu.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    FilesystemPopup {
        id: filesystemPopup
        anchorWindow: bar
        anchorX: filesystem.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    MemoryPopup {
        id: memoryPopup
        anchorWindow: bar
        anchorX: memory.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    WifiPopup {
        id: wifiPopup
        anchorWindow: bar
        anchorX: wifi.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // ====================================================================
    // Center block: network, battery, cpu, thermals, fan, memory, filesystem
    // ====================================================================
    Row {
        id: centerRow

        // Fixed-center, like polybar: the block is centered on the bar, not
        // on the space left over between the other two blocks. If centering
        // would push it into a neighbour it slides instead, which polybar
        // would simply have overlapped.
        y: (bar.height - height) / 2
        x: {
            var ideal = (bar.width - width) / 2;
            var minX = leftGroup.x + leftGroup.width + bar.groupGap;
            var maxX = rightGroup.x - width - bar.groupGap;
            return Math.max(minX, Math.min(ideal, maxX));
        }
        spacing: bar.moduleSpacing

        // polybar [module/wireless-network]
        Wifi {
            id: wifi
            height: bar.height
            visible: bar.layout.shown[0]
            compact: bar.layout.compact
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(wifiPopup)
            }
        }

        // polybar [module/battery], on the native UPower service
        Battery {
            id: battery
            height: bar.height
            visible: bar.layout.shown[1]
            compact: bar.layout.compact
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(batteryPopup)
            }
        }

        // polybar [module/sep]
        Text {
            id: sepA
            height: bar.height
            visible: bar.layout.shown[2]
            verticalAlignment: Text.AlignVCenter
            text: " \u2503"
            // Counted in the width budget like everything else; see the layout
            // block at the bottom of this file.
            readonly property real fullWidth: implicitWidth
            readonly property real compactWidth: implicitWidth
            color: bar.colors.sepBright
            // CurveRendering is grayscale antialiasing, which is what polybar's
            // Xft rendering produced. Qt's default adds colour fringes that make
            // the text look a size thinner than polybar's.
            renderType: Text.CurveRendering
            font.family: bar.fontFamily
            font.pixelSize: bar.fontSize
            font.bold: bar.fontBold
        }

        // polybar [module/cpu]
        Cpu {
            id: cpu
            height: bar.height
            visible: bar.layout.shown[3]
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(cpuPopup)
            }
        }

        // polybar [module/temperature] (CPU, cros_ec)
        Temperature {
            id: tempCpu
            height: bar.height
            visible: bar.layout.shown[4]
            path: "/sys/class/hwmon/hwmon3/temp2_input"
            prefix: "\uf4bc "
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
        }

        // polybar [module/temperature-gpu] (amdgpu)
        Temperature {
            id: tempGpu
            height: bar.height
            visible: bar.layout.shown[5]
            path: "/sys/class/hwmon/hwmon1/temp1_input"
            prefix: "\u{f0aa4} "
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
        }

        // polybar [module/temperature-ssd] (nvme)
        Temperature {
            id: tempSsd
            height: bar.height
            visible: bar.layout.shown[6]
            path: "/sys/class/hwmon/hwmon0/temp1_input"
            prefix: "\u{f02ca} "
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
        }

        // polybar [module/fan] (custom/script -> polybar/scripts/fan)
        ScriptModule {
            id: fan
            height: bar.height
            visible: bar.layout.shown[7]
            command: [bar.scriptDir + "/fan"]
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
            prefix: "\uefa7 "
        }

        // polybar [module/sep]
        Text {
            id: sepB
            height: bar.height
            visible: bar.layout.shown[8]
            verticalAlignment: Text.AlignVCenter
            text: " \u2503"
            readonly property real fullWidth: implicitWidth
            readonly property real compactWidth: implicitWidth
            color: bar.colors.sepBright
            // CurveRendering is grayscale antialiasing, which is what polybar's
            // Xft rendering produced. Qt's default adds colour fringes that make
            // the text look a size thinner than polybar's.
            renderType: Text.CurveRendering
            font.family: bar.fontFamily
            font.pixelSize: bar.fontSize
            font.bold: bar.fontBold
        }

        // polybar [module/memory] (custom/script -> polybar/scripts/memory)
        ScriptModule {
            id: memory
            height: bar.height
            visible: bar.layout.shown[9]
            command: [bar.scriptDir + "/memory"]
            compactCommand: [bar.scriptDir + "/memory", "short"]
            compact: bar.layout.compact
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground
            prefix: " "

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(memoryPopup)
            }
        }

        // polybar [module/filesystem] (custom/script -> polybar/scripts/filesystem)
        ScriptModule {
            id: filesystem
            height: bar.height
            visible: bar.layout.shown[10]
            command: [bar.scriptDir + "/filesystem"]
            compactCommand: [bar.scriptDir + "/filesystem", "short"]
            compact: bar.layout.compact
            interval: 10
            fontSize: bar.fontSize
            fontFamily: bar.fontFamily
            fontBold: bar.fontBold
            color: bar.colors.foreground

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(filesystemPopup)
            }
        }
    }

    // ====================================================================
    // How the center block gives up space
    // ====================================================================
    //
    // Two steps, in this order:
    //
    //   1. If the full-detail modules do not fit, switch to the short forms
    //      (memory and filesystem from their scripts' "short" argument, and
    //      the battery's time/wattage dropped).
    //   2. If even the short forms do not fit, hide the least important
    //      modules.
    //
    // Nothing here can touch the left or right blocks, so the clock is safe.
    //
    // The entries are in polybar's module order. `prio` is the keep-priority:
    // the lower the number, the longer the module survives. The separators
    // carry the highest number, so they are considered last and are the first
    // thing to go; on top of that a separator is only drawn when a module is
    // visible on both sides of it.
    readonly property var centerEntries: [
        { item: wifi, prio: 1, sep: false },
        { item: battery, prio: 1, sep: false },
        { item: sepA, prio: 100, sep: true },
        { item: cpu, prio: 2, sep: false },
        { item: tempCpu, prio: 2, sep: false },
        { item: tempGpu, prio: 5, sep: false },
        { item: tempSsd, prio: 6, sep: false },
        { item: fan, prio: 8, sep: false },
        { item: sepB, prio: 100, sep: true },
        { item: memory, prio: 3, sep: false },
        { item: filesystem, prio: 7, sep: false }
    ]

    // Room left for the center block once the other two have taken theirs.
    readonly property real centerAvailable:
        rightGroup.x - leftGroup.x - leftGroup.width - 2 * groupGap

    // Which entries fit, and in which form.
    //
    // Every module reports both a full and a compact width (see
    // modules/ScriptModule.qml), measured independently of what is currently
    // on screen. That is what makes this solvable: the answer never depends on
    // its own result, so there is no binding loop and no flicker.
    //
    // Reading each item's width here is also what re-runs this whenever a
    // module's text changes -- which is what happens when the battery starts
    // discharging and grows a time-remaining and a wattage field.
    readonly property var layout: {
        var entries = centerEntries;
        var gap = moduleSpacing;
        var avail = centerAvailable;

        // Total width of a set of entries, spacing included.
        function totalOf(vis, field) {
            var sum = 0;
            var count = 0;
            for (var i = 0; i < entries.length; i++) {
                if (!vis[i]) continue;
                sum += entries[i].item[field];
                count += 1;
            }
            return sum + gap * Math.max(0, count - 1);
        }

        var all = [];
        for (var a = 0; a < entries.length; a++) all[a] = true;

        // Step 1: do the long forms fit?
        var compact = totalOf(all, "fullWidth") > avail;
        var field = compact ? "compactWidth" : "fullWidth";

        // Step 2: keep the most important entries that fit, separators last.
        var vis = [];
        var used = 0;
        var count = 0;

        var order = entries
            .map(function (e, i) { return { e: e, i: i }; })
            .sort(function (x, y) { return x.e.prio - y.e.prio; });

        for (var n = 0; n < order.length; n++) {
            var o = order[n];
            var add = (count > 0 ? gap : 0) + o.e.item[field];
            // The first entry is kept even if it alone does not fit, so the
            // block is never completely empty.
            if (count === 0 || used + add <= avail) {
                used += add;
                count += 1;
                vis[o.i] = true;
            } else {
                vis[o.i] = false;
            }
        }

        // A separator shows only between two visible modules. Dropping one can
        // only free space, so the block still fits afterwards.
        for (var i2 = 0; i2 < entries.length; i2++) {
            if (!entries[i2].sep) continue;
            var before = false;
            var after = false;
            for (var j = i2 - 1; j >= 0; j--) {
                if (!entries[j].sep) { before = vis[j] === true; break; }
            }
            for (var k = i2 + 1; k < entries.length; k++) {
                if (!entries[k].sep) { after = vis[k] === true; break; }
            }
            vis[i2] = before && after;
        }

        return { compact: compact, shown: vis };
    }
}
