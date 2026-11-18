// File: quickshell/modules/Wifi.qml
//
// The polybar [module/wireless-network] replacement, on interface wlp1s0.
// polybar read the link with libnl; this reads the same information from
// NetworkManager through quickshell's Quickshell.Networking service.
//
// polybar cut the SSID to 10 characters plus an ellipsis because a bar of
// fixed-width modules had no way to make room. Here that cut is the *compact*
// form instead: the whole name is shown whenever it fits, and the bar falls
// back to the 10-character form only when it does not. See the layout block in
// Bar.qml.
import Quickshell.Networking
import QtQuick

Text {
    id: root

    property bool compact: false
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    readonly property var device: {
        var devices = Networking.devices.values;
        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wifi) return devices[i];
        }
        return null;
    }

    readonly property var network: {
        var wifi = device;
        if (!wifi) return null;
        var networks = wifi.networks.values;
        for (var i = 0; i < networks.length; i++) {
            if (networks[i].connected) return networks[i];
        }
        return null;
    }

    readonly property string essid: network ? network.name : ""

    readonly property int signal: (network && network.signalStrength !== undefined)
                                  ? Math.round(network.signalStrength * 100)
                                  : 0

    // polybar's "%essid:0:10:…%" rule, now only used as the fallback.
    readonly property string shortEssid:
        essid.length > 10 ? essid.substring(0, 10) + "\u2026" : essid

    // Even the long form is capped, so one absurd SSID cannot crowd out the
    // rest of the bar on its own.
    readonly property string longEssid:
        essid.length > 24 ? essid.substring(0, 24) + "\u2026" : essid

    readonly property string icons: "\uf1eb  "
    readonly property string signalPart: " \u{f04a2} " + String(signal).padStart(2, " ")

    // polybar: label-connected = "<wifi>  %essid:0:10:…% <signal bars> %signal:2%"
    //          label-disconnected (its default) = "%ifname% disconnected"
    readonly property string longText: network
                                       ? icons + longEssid + signalPart
                                       : (device ? device.name + " disconnected" : "")

    readonly property string shortText: network ? icons + shortEssid + signalPart : longText

    readonly property bool hasShortForm: network !== null

    readonly property real fullWidth: longMetrics.advanceWidth
    readonly property real compactWidth: shortMetrics.advanceWidth

    text: (compact && hasShortForm) ? shortText : longText

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
