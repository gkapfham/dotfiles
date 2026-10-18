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
//          # exec_always --no-startup-id quickshell -n
//          exec_always --no-startup-id ~/.config/polybar/scripts/polybar-launch.sh
//
//   2. Stop this bar and reload i3:
//
//          quickshell kill
//          i3-msg reload            (or $mod+Shift+r)
//
// To drop the bar altogether, delete the two `exec_always` lines instead.
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
    // One palette object, shared by every bar (see Colors.qml).
    Colors {
        id: palette
    }

    // One bar per connected monitor, which is what polybar-launch.sh did by
    // starting `polybar mybar` once per monitor. Quickshell tracks hotplugged
    // monitors for us, so no xrandr loop and no relaunch is needed.
    Variants {
        model: Quickshell.screens

        // Bar.qml declares the `modelData` property that Variants fills in;
        // declaring it here as well would shadow that one and leave the bar
        // without a screen.
        delegate: Bar {
            colors: palette
        }
    }
}
