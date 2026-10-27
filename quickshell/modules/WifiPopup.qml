// File: quickshell/modules/WifiPopup.qml
//
// Clicking the Wi-Fi module opens this: the link details and, more usefully,
// what the connection is actually carrying right now.
//
// Two sources, because neither covers everything:
//   * quickshell's Networking service for the SSID and the signal percentage,
//     which is what the bar itself shows;
//   * `iw` for the frequency and the negotiated bitrates, and the kernel's
//     byte counters for the live transfer rate, neither of which the service
//     exposes.
import Quickshell.Networking
import Quickshell.Io
import QtQuick

InfoPopup {
    id: popup

    property string frequency: "\u2014"
    property string signalDbm: ""
    property string rxBitrate: "\u2014"
    property string txBitrate: "\u2014"
    property string download: "\u2014"
    property string upload: "\u2014"

    property real lastRx: -1
    property real lastTx: -1
    property real lastSample: 0

    title: "Network"
    popupWidth: 300

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

    readonly property string interfaceName: device ? device.name : ""

    readonly property string signalText: {
        if (!network) return "\u2014";
        var percent = network.signalStrength !== undefined
                      ? Math.round(network.signalStrength * 100) + "%" : "";
        if (signalDbm !== "") return percent !== "" ? percent + "  (" + signalDbm + ")" : signalDbm;
        return percent !== "" ? percent : "\u2014";
    }

    rows: [
        { label: "Network", value: network ? network.name : "\u2014" },
        { label: "Interface", value: interfaceName !== "" ? interfaceName : "\u2014" },
        { label: "Signal", value: signalText },
        { label: "Frequency", value: frequency },
        { label: "RX link", value: rxBitrate },
        { label: "TX link", value: txBitrate },
        { label: "Download", value: download },
        { label: "Upload", value: upload }
    ]

    Process {
        id: iw

        stdout: StdioCollector {
            onStreamFinished: popup.parseIw(text)
        }
    }

    FileView {
        id: rxBytes
        path: popup.interfaceName !== ""
              ? "/sys/class/net/" + popup.interfaceName + "/statistics/rx_bytes" : ""
    }

    FileView {
        id: txBytes
        path: popup.interfaceName !== ""
              ? "/sys/class/net/" + popup.interfaceName + "/statistics/tx_bytes" : ""
    }

    // Only polled while the popup is open; nothing here is worth the work when
    // nobody is looking at it.
    Timer {
        interval: 1000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: {
            popup.sampleTransfer();
            rxBytes.reload();
            txBytes.reload();
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: popup.visible
        triggeredOnStart: true

        onTriggered: {
            if (popup.interfaceName !== "") {
                iw.exec(["iw", "dev", popup.interfaceName, "link"]);
            }
        }
    }

    // Reads the counters as they stand from the previous tick, so this reports
    // the interval that just ended rather than the one that has not happened.
    function sampleTransfer() {
        var rx = parseInt(rxBytes.text().trim(), 10);
        var tx = parseInt(txBytes.text().trim(), 10);
        var now = Date.now();

        if (popup.lastSample > 0 && !isNaN(rx) && !isNaN(tx) && rx >= popup.lastRx && tx >= popup.lastTx) {
            var seconds = (now - popup.lastSample) / 1000;
            popup.download = popup.rate(rx - popup.lastRx, seconds);
            popup.upload = popup.rate(tx - popup.lastTx, seconds);
        }

        if (!isNaN(rx)) popup.lastRx = rx;
        if (!isNaN(tx)) popup.lastTx = tx;
        popup.lastSample = now;
    }

    function rate(bytes, seconds) {
        if (seconds <= 0 || bytes < 0) return "\u2014";
        var perSecond = bytes / seconds;
        if (perSecond >= 1e6) return (perSecond / 1e6).toFixed(1) + " MB/s";
        if (perSecond >= 1e3) return (perSecond / 1e3).toFixed(1) + " KB/s";
        return perSecond.toFixed(0) + " B/s";
    }

    function parseIw(text) {
        var match;

        if ((match = text.match(/signal:\s*(-?\d+)\s*dBm/))) {
            popup.signalDbm = match[1] + " dBm";
        }
        if ((match = text.match(/freq:\s*([\d.]+)/))) {
            popup.frequency = Math.round(parseFloat(match[1])) + " MHz";
        }
        if ((match = text.match(/rx bitrate:\s*([\d.]+)\s*MBit\/s/))) {
            popup.rxBitrate = match[1] + " Mb/s";
        }
        if ((match = text.match(/tx bitrate:\s*([\d.]+)\s*MBit\/s/))) {
            popup.txBitrate = match[1] + " Mb/s";
        }
    }
}
