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

    // Emitted by the toggle icon in the status plate. shell.qml owns the actual
    // visibility state, because every screen's bar hides and shows together; this
    // bar only reports the request.
    signal toggleRequested()

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

    // The fill for every plate on the bar: wifi, battery, cpu, storage, the
    // status icons and the device controls.
    //
    // Drawn at 75% over the bar background rather than as a solid primary. Two
    // reasons, both measured. Legibility: a solid #444444 leaves the dim state
    // (foregroundAlt, used for an off bluetooth and a dimmed agent icon) at
    // 4.1:1, below the WCAG AA threshold of 4.5, where the same glyph on plain
    // background sits at 7.2:1. At 75% the effective fill is about #3a3a3a, the
    // dim state reaches 4.8:1 and the foreground 8.6:1. Weight: a solid plate
    // this wide dominated the bar it was meant to group.
    //
    // The focused-workspace label is deliberately NOT this colour. It is a
    // selection indicator rather than a grouping plate, and it keeps polybar's
    // solid primary.
    readonly property color plateColor:
        Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.75)

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
        zellijPopup.visible = false;
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

        // The status icons sit on their own plate: a filled rounded rectangle
        // behind all of them. The bar already draws a filled plate behind
        // the focused workspace label, so this is a second use of the same idea
        // rather than a new visual language, and it groups the icons without a
        // divider glyph and without spending part of the bar on whitespace.
        //
        // None of them is a polybar module: polybar had no bluetooth
        // indicator, no notification history, no notion of an agent and no
        // notion of a multiplexer session.
        Rectangle {
            id: statusPlate

            anchors.verticalCenter: parent.verticalCenter
            // Hugs the glyphs: the row's own width plus 8px of padding on each
            // side, the same padding the workspace label uses.
            implicitWidth: statusRow.implicitWidth + 16
            height: 18
            radius: 4
            color: bar.plateColor

            Row {
                id: statusRow

                anchors.centerIn: parent
                // Optical centring: the text is centred by its line box, which
                // includes descent room that these icons never use, so the ink
                // sat ~1px high inside the plate. Half a logical pixel -- one
                // physical pixel at this 2x scale -- centres the ink.
                anchors.verticalCenterOffset: 0.5
                // Set explicitly: the children take `height: statusRow.height`,
                // and a Row's own height is derived from its children, so
                // leaving it out is a binding loop that collapses the row -- and
                // with it every glyph on the plate -- to zero.
                height: parent.height
                spacing: bar.moduleSpacing

                Bluetooth {
                    id: bluetooth
                    height: statusRow.height
                    color: bar.colors.foreground
                    dimColor: bar.colors.foregroundAlt
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                }

                // The NetBird tunnel switch, beside the bluetooth one and for
                // the same reason: the icon is the switch. Unlike bluetooth it
                // has no quickshell service behind it, so the state and the
                // toggle both go through the netbird CLI -- see
                // modules/Netbird.qml for why the bar is allowed to call it.
                Netbird {
                    id: netbird
                    height: statusRow.height
                    // Not `color`: the module binds `color` itself to pick
                    // between these two, and an assignment here would replace
                    // that binding.
                    activeColor: bar.colors.foreground
                    dimColor: bar.colors.foregroundAlt
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                }

                // Hides the bar. The way back is the reveal strip at the top edge
                // of the screen (shell.qml), not this icon: hiding the bar unmaps
                // the icon with it.
                BarToggle {
                    id: barToggle
                    height: statusRow.height
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bar.toggleRequested()
                    }
                }

                // A bell for dunst's notification history.
                Notifications {
                    id: notifications
                    height: statusRow.height
                    color: bar.colors.foreground
                    dimColor: bar.colors.foregroundAlt
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                }

                // A robot for the pi coding agents running on this machine. It
                // carries no count by design: the number is in the popup, one
                // click away.
                PiAgents {
                    id: agents
                    height: statusRow.height
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

                // A list glyph for zellij sessions, and how many agents live in
                // each.
                ZellijSessions {
                    id: zellij
                    height: statusRow.height
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bar.togglePopup(zellijPopup)
                    }
                }
            }
        }

        // A wider gap separates the plate from the device controls, so the plate
        // reads as its own region rather than as the first of five modules.
        Item {
            id: statusSpacer

            width: bar.moduleSpacing
        }

        // Brightness and volume on one plate: the two things you adjust while
        // working. The clock stays outside it deliberately -- it is the one
        // reading that is never a knob, and it is unchanged.
        Rectangle {
            id: devicePlate

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: deviceRow.implicitWidth + 16
            height: 18
            radius: 4
            color: bar.plateColor

            Row {
                id: deviceRow

                // Optical centring: the text is centred by its line box, which
                // includes descent room that digits, caps and icons do not use,
                // so the visible ink sat ~1px high inside the plate (measured:
                // top padding 5px, bottom 7px). Half a logical pixel -- one
                // physical pixel at this 2x scale -- puts the ink in the middle.
                anchors.verticalCenterOffset: 0.5
                anchors.centerIn: parent
                height: parent.height
                spacing: bar.moduleSpacing

                // polybar [module/backlight]
                Backlight {
                    height: deviceRow.height
                    interval: 15
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground
                }

                // polybar [module/pulseaudio]
                Volume {
                    height: deviceRow.height
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground
                }
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
        anchorX: agents.x + agents.parent.x + statusPlate.x + rightGroup.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    // Opened by clicking the tab glyph. A child of this window because it
    // anchors to it.
    ZellijSessionsPopup {
        id: zellijPopup
        anchorWindow: bar
        anchorX: zellij.x + zellij.parent.x + statusPlate.x + rightGroup.x
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
        anchorX: batteryPlate.x + battery.x + centerRow.x
        // Taken from the module rather than from UPower directly, so the popup's
        // Source row always matches the icon in the bar.
        onBattery: battery.onBattery
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    CpuPopup {
        id: cpuPopup
        anchorWindow: bar
        anchorX: cpuPlate.x + cpuRow.x + cpu.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    FilesystemPopup {
        id: filesystemPopup
        anchorWindow: bar
        anchorX: storagePlate.x + storageRow.x + filesystem.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    MemoryPopup {
        id: memoryPopup
        anchorWindow: bar
        anchorX: storagePlate.x + storageRow.x + memory.x + centerRow.x
        colors: bar.colors
        fontSize: bar.fontSize
        fontFamily: bar.fontFamily
        fontBold: bar.fontBold
    }

    WifiPopup {
        id: wifiPopup
        anchorWindow: bar
        anchorX: wifiPlate.x + wifi.x + centerRow.x
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
        // Centred in the space *between* the side blocks, not on the bar.
        //
        // polybar centred the block on the bar, and that was copied here, but it
        // only looks balanced while the two side blocks are the same width. The
        // right block is now ~150px wider than the left (four status icons plus
        // backlight, volume and the clock), so bar-centring left 107 logical px
        // on one side and 21 on the other and the block read as pushed right.
        //
        // Everything here is derived from the actual block geometry, so it holds
        // on any screen size: minX and maxX are the real limits the block may
        // occupy, and the midpoint between them gives equal gaps. When there is
        // no room at all the clamps collapse to minX, which is where the sliding
        // behaviour already put it.
        x: {
            var minX = leftGroup.x + leftGroup.width + bar.groupGap;
            var maxX = rightGroup.x - width - bar.groupGap;
            var ideal = minX + (maxX - minX) / 2;
            return Math.max(minX, Math.min(ideal, maxX));
        }
        spacing: bar.moduleSpacing

        // The two readings that matter most on a laptop -- the network it is on
        // and the power it is running from -- sit on plates: the same filled
        // rounded rectangle the focused workspace and the status icons use. The
        // rest of the block stays plain glyphs, so a plate here marks importance
        // rather than grouping for its own sake.
        //
        // Each plate forwards its child's full and compact widths to the layout's
        // width budget, plus the 8px of padding on each side, and takes the same
        // width from that budget, so the block still sizes itself from real
        // content and the budget matches what is on screen.
        Rectangle {
            id: wifiPlate

            readonly property real fullWidth: wifi.fullWidth + 16
            readonly property real compactWidth: wifi.compactWidth + 16

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: bar.layout.compact ? compactWidth : fullWidth
            height: 18
            radius: 4
            color: bar.plateColor
            visible: bar.layout.shown[0]

            // The whole plate is the click target, not just the text inside it:
            // the plate is 8px wider than its module on each side, and clicks in
            // that padding used to fall through to nothing.
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(wifiPopup)
            }

            // polybar [module/wireless-network]
            Wifi {
                id: wifi
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0.5
                height: parent.height
                compact: bar.layout.compact
                fontSize: bar.fontSize
                fontFamily: bar.fontFamily
                fontBold: bar.fontBold
                color: bar.colors.foreground
            }
        }

        Rectangle {
            id: batteryPlate

            readonly property real fullWidth: battery.fullWidth + 16
            readonly property real compactWidth: battery.compactWidth + 16

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: bar.layout.compact ? compactWidth : fullWidth
            height: 18
            radius: 4
            color: bar.plateColor
            visible: bar.layout.shown[1]

            // The whole plate is the click target; see the note on wifiPlate.
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(batteryPopup)
            }

            // polybar [module/battery], on the native UPower service
            Battery {
                id: battery
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0.5
                height: parent.height
                compact: bar.layout.compact
                fontSize: bar.fontSize
                fontFamily: bar.fontFamily
                fontBold: bar.fontBold
                color: bar.colors.foreground
            }
        }

        // CPU usage, every temperature reading and the fan share a plate. They
        // are all readings of the same silicon -- package, GPU and NVMe -- and
        // the fan is what cools them, so together they answer one question: how
        // hard is this machine working and how well is it coping.
        Rectangle {
            id: cpuPlate

            readonly property real fullWidth: cpu.fullWidth + tempCpu.fullWidth
                                               + tempGpu.fullWidth + tempSsd.fullWidth
                                               + fan.fullWidth + 4 * bar.moduleSpacing + 16
            readonly property real compactWidth: cpu.compactWidth + tempCpu.compactWidth
                                                  + tempGpu.compactWidth + tempSsd.compactWidth
                                                  + fan.compactWidth + 4 * bar.moduleSpacing + 16

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: bar.layout.compact ? compactWidth : fullWidth
            height: 18
            radius: 4
            color: bar.plateColor
            visible: bar.layout.shown[2]

            // The whole plate is the click target, not just the CPU text inside
            // it. The plate is 8px wider than its contents on each side, and the
            // temperatures and fan sit beside the usage, so clicks used to fall
            // through to nothing unless they landed on the CPU number itself.
            // Same treatment as wifi, battery and the status icons.
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.togglePopup(cpuPopup)
            }

            Row {
                id: cpuRow

                // Optical centring: the text is centred by its line box, which
                // includes descent room that digits, caps and icons do not use,
                // so the visible ink sat ~1px high inside the plate (measured:
                // top padding 5px, bottom 7px). Half a logical pixel -- one
                // physical pixel at this 2x scale -- puts the ink in the middle.
                anchors.verticalCenterOffset: 0.5
                anchors.centerIn: parent
                height: parent.height
                spacing: bar.moduleSpacing

                // polybar [module/cpu]
                Cpu {
                    id: cpu
                    height: cpuRow.height
                    interval: 10
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground
                }

                // polybar [module/temperature] (CPU, cros_ec)
                Temperature {
                    id: tempCpu
                    height: cpuRow.height
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
                    height: cpuRow.height
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
                    height: cpuRow.height
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
                    height: cpuRow.height
                    command: [bar.scriptDir + "/fan"]
                    interval: 10
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground
                    prefix: "\uefa7 "
                }
            }
        }

        // Memory and disk on one plate: both are storage, and the two together
        // answer "have I run out of room".
        Rectangle {
            id: storagePlate

            readonly property real fullWidth: memory.fullWidth + filesystem.fullWidth
                                               + bar.moduleSpacing + 16
            readonly property real compactWidth: memory.compactWidth + filesystem.compactWidth
                                                  + bar.moduleSpacing + 16

            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: bar.layout.compact ? compactWidth : fullWidth
            height: 18
            radius: 4
            color: bar.plateColor
            visible: bar.layout.shown[3]

            Row {
                id: storageRow

                // Optical centring: the text is centred by its line box, which
                // includes descent room that digits, caps and icons do not use,
                // so the visible ink sat ~1px high inside the plate (measured:
                // top padding 5px, bottom 7px). Half a logical pixel -- one
                // physical pixel at this 2x scale -- puts the ink in the middle.
                anchors.verticalCenterOffset: 0.5
                anchors.centerIn: parent
                height: parent.height
                spacing: bar.moduleSpacing

                // polybar [module/memory] (custom/script -> polybar/scripts/memory)
                ScriptModule {
                    id: memory
                    height: storageRow.height
                    command: [bar.scriptDir + "/memory"]
                    compactCommand: [bar.scriptDir + "/memory", "short"]
                    compact: bar.layout.compact
                    interval: 10
                    fontSize: bar.fontSize
                    fontFamily: bar.fontFamily
                    fontBold: bar.fontBold
                    color: bar.colors.foreground
                    // polybar's format-prefix was " ". Inside the storage plate
                    // that gap is the plate's padding, and keeping it made the
                    // memory module sit further from its plate edge than the
                    // filesystem module beside it.
                    prefix: ""

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bar.togglePopup(memoryPopup)
                    }
                }

                // polybar [module/filesystem] (custom/script -> polybar/scripts/filesystem)
                ScriptModule {
                    id: filesystem
                    height: storageRow.height
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
        { item: wifiPlate, prio: 1, sep: false },
        { item: batteryPlate, prio: 1, sep: false },
        { item: cpuPlate, prio: 2, sep: false },
        { item: storagePlate, prio: 3, sep: false }
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
