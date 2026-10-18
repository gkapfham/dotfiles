// File: quickshell/modules/Battery.qml
//
// The polybar [module/battery] replacement, on quickshell's native UPower
// service instead of polybar/scripts/battery.
//
// Why not the script: it divided charge by current, and this Framework's EC
// reports a discharge current of about 1 mA even when the machine is plugged
// in and full. That produced "3326h" and "0.02 W". UPower reads the same
// sensor but reports the estimate in seconds and the rate in watts, and it
// zeroes whichever of time-to-empty / time-to-full does not apply.
//
// UPower alone is not enough, though: at a rate of 0.015 W it still claims
// 138 days of runtime. So an estimate is only shown when the rate is at least
// `minRate` watts. A near-zero rate cannot support an estimate, and printing
// one anyway is what made the old label look broken.
import Quickshell.Services.UPower
import QtQuick

Text {
    id: root

    property bool compact: false
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // The icons polybar/scripts/battery drew, codepoint for codepoint, so the
    // label still looks like the one polybar produced.
    readonly property string batteryIcon: "\u{f0079}"
    readonly property string upIcon: "\u{f2fa}"
    readonly property string downIcon: "\u{f2f8}"
    readonly property string fullIcon: "\u{ee29}"
    readonly property string clockIcon: "\u{f0954}"
    readonly property string boltIcon: "\u{f0ce7}"

    // Below this many watts the reading is sensor noise, so no time or
    // wattage is shown at all.
    readonly property real minRate: 1.0

    readonly property var device: UPower.displayDevice
    readonly property bool ready: device ? device.ready : false
    readonly property int percent: ready ? Math.round(device.percentage * 100) : 0
    readonly property int state: ready ? device.state : UPowerDeviceState.Unknown

    // UPower.onBattery is the reliable "am I on wall power" signal, and the
    // battery's own state is not. This Framework's EC reports the pack as
    // `Discharging` even while the adapter is connected (current_now sits at
    // about 1 mA and the adapter is online), and UPower passes that state
    // through unchanged. Trusting `state` alone is what put a discharge arrow
    // on a plugged-in laptop.
    readonly property bool onBattery: UPower.onBattery
    readonly property bool charging: state === UPowerDeviceState.Charging
    readonly property bool discharging: onBattery
    readonly property bool full: !onBattery && !charging

    // polybar/scripts/battery picks the prefix from the charging state. The
    // script added a trailing space for the full marker on top of the space
    // before the percentage, which left two spaces and pushed "100%" away
    // from the icon; the icons are spaced the same way here instead.
    readonly property string prefix: full
                                     ? batteryIcon + fullIcon
                                     : charging
                                       ? batteryIcon + upIcon
                                       : batteryIcon + downIcon

    readonly property real rate: ready ? Math.abs(device.changeRate) : 0

    readonly property real seconds: charging
                                    ? device.timeToFull
                                    : discharging
                                      ? device.timeToEmpty
                                      : 0

    readonly property bool showEstimate: ready && rate >= minRate && seconds > 0

    // polybar/scripts/battery printed "1h20" once there was an hour or more
    // and "45m" otherwise, then cut the result to five characters.
    readonly property string timeText: {
        if (!showEstimate) return "";
        var minutes = Math.round(seconds / 60);
        var hours = Math.floor(minutes / 60);
        var rest = minutes % 60;
        var text = hours > 0 ? hours + "h" + String(rest).padStart(2, "0") : rest + "m";
        return text.substring(0, 5);
    }

    readonly property string rateText:
        showEstimate ? (rate.toFixed(2) + "").substring(0, 5) : ""

    readonly property string shortText: prefix + " " + percent + "%"

    readonly property string longText: {
        var label = shortText;
        if (timeText !== "") label += " " + clockIcon + " " + timeText;
        if (rateText !== "") label += " " + boltIcon + " " + rateText;
        return label;
    }

    // Both widths are measured regardless of which one is on screen, so the
    // bar can size the block without the answer depending on its own result.
    readonly property real fullWidth: longMetrics.advanceWidth
    readonly property real compactWidth: shortMetrics.advanceWidth

    text: compact ? shortText : longText

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold

    TextMetrics {
        id: longMetrics
        font: root.font
        text: root.longText
    }

    TextMetrics {
        id: shortMetrics
        font: root.font
        text: root.shortText
    }
}
