// File: quickshell/shell.qml
//
// The quickshell replacement for the polybar bar in polybar/config.ini.
// Run it with `quickshell` (or `qs`), which reads this file as the default
// config from ~/.config/quickshell/shell.qml.
//
// ---------------------------------------------------------------------------
// How this maps onto polybar
// ---------------------------------------------------------------------------
// polybar/config.ini had a [bar/mybar] section plus one [module/*] section per
// module, and polybar/scripts/polybar-launch.sh started one `polybar mybar`
// per monitor, choosing a bar by panel width. Here:
//
//   [bar/mybar]        -> Bar.qml (one instance per screen, via Variants)
//   [module/i3]        -> modules/Workspaces.qml
//   [module/wireless]  -> modules/Wifi.qml
//   [module/cpu]       -> modules/Cpu.qml
//   [module/temperature*] -> modules/Temperature.qml
//   [module/backlight] -> modules/Backlight.qml
//   [module/pulseaudio]-> modules/Volume.qml
//   [module/date]      -> the clock Text in Bar.qml
//   [module/battery]   -> modules/Battery.qml (native UPower, not the script)
//   custom/script modules (fan, memory, filesystem)
//                      -> modules/ScriptModule.qml, running the very same
//                         scripts out of polybar/scripts/
//
// ---------------------------------------------------------------------------
// HOW TO REVERT TO POLYBAR
// ---------------------------------------------------------------------------
// Nothing in polybar/ was deleted or rewritten, so reverting is one line:
//
//   1. In i3/config, comment out the quickshell line and uncomment the polybar
//      line directly beneath it (both are marked with comments):
//
//          # exec_always --no-startup-id ~/.config/i3/scripts/quickshell-launch.sh
//          exec_always --no-startup-id ~/.config/polybar/scripts/polybar-launch.sh
//
//   2. Stop this bar and reload i3:
//
//          quickshell kill
//          i3-msg reload            (or $mod+Shift+r)
//
// To drop the bar altogether, delete the two `exec_always` lines instead.
//
// Starting and stopping it by hand is what i3/scripts/quickshell-launch.sh is
// for: `quickshell-launch.sh status` says whether the bar is healthy,
// `restart` stops it and starts a fresh copy, and `stop` just stops it. A bar
// stopped by hand comes back on the next i3 reload, because i3 re-runs the
// exec_always line that starts it.
//
// DO NOT use `pkill -x quickshell` to stop it. The Nix wrapper execs
// `.quickshell-wrapped`, so the process name is `.quickshell-wra`, not
// `quickshell`; an exact-name match (-x) finds nothing, exits 1, and says
// nothing about why. `quickshell kill` is the supported way.
//
// polybar has the identical trap: stop it with `pkill polybar` (no -x), never
// `pkill -x polybar`, or it will appear to do nothing.
// ---------------------------------------------------------------------------
import Quickshell
import QtQuick

ShellRoot {
    id: root

    // Whether the bars are shown. Owned here rather than in Bar.qml because it is
    // one decision for the process: every screen's bar hides and shows together.
    property bool barVisible: true

    // One palette object, shared by every bar (see Colors.qml).
    Colors {
        id: palette
    }

    // One bar per *place on the desk*, not per screen object.
    //
    // An output that comes back on a new connector name can leave the old one
    // behind as a phantom monitor at the same x/y: on 2026-10-21 the 4K panel
    // moved from DP-7 to DP-8 while xrandr kept both at +0+0, so quickshell saw
    // three screens and drew three bars -- two stacked at the top of the 4K
    // panel and one on the laptop. Everything at one position is one place, so
    // only the first screen there gets a bar.
    //
    // i3/scripts/quickshell-launch.sh turns the phantom output itself off, which
    // is the real fix. This is the second line of defence, for a monitor that is
    // plugged in while the bar is already running and the launcher is not there
    // to run.
    readonly property var barScreens: {
        var seen = {};
        var unique = [];

        for (var i = 0; i < Quickshell.screens.length; i++) {
            var s = Quickshell.screens[i];
            var at = s.x + "," + s.y;
            if (seen[at] === true) continue;
            seen[at] = true;
            unique.push(s);
        }

        return unique;
    }

    // One bar per connected monitor, which is what polybar-launch.sh did by
    // starting `polybar mybar` once per monitor. Quickshell tracks hotplugged
    // monitors for us, so no xrandr loop and no relaunch is needed.
    Variants {
        model: root.barScreens

        // Bar.qml declares the `modelData` property that Variants fills in;
        // declaring it here as well would shadow that one and leave the bar
        // without a screen.
        delegate: Bar {
            colors: palette
            visible: root.barVisible
            onToggleRequested: root.barVisible = !root.barVisible
        }
    }

    // ---- the reveal strip ----------------------------------------------------
    //
    // The bar's toggle icon cannot be its own way back: hiding the bar unmaps
    // the icon with it. This is the way back -- a 2 logical px band along the top
    // edge of every screen, mapped only while the bar is hidden. Touching it
    // brings the bar back.
    //
    // The details below are the ones that matter on X11 under i3:
    //
    //   - exclusiveZone 0 with ExclusionMode.Ignore, so the strip reserves no
    //     space at all. Without that, hiding the bar would still cost its height
    //     and the whole exercise would be pointless.
    //   - it is a dock window like the bar itself, so i3 keeps it stacked above
    //     normal windows and the pointer reaches it even over a maximized window.
    //   - it draws nothing and reacts only to pointer entry, so it cannot be
    //     clicked by accident and never takes keyboard focus from i3.
    //
    // It is one window per screen, not one in total, because each screen has its
    // own top edge.
    Variants {
        model: root.barScreens

        delegate: PanelWindow {
            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 2

            visible: !root.barVisible
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: root.barVisible = true
            }
        }
    }
}
