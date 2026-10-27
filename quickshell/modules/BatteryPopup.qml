// File: quickshell/modules/BatteryPopup.qml
//
// The battery's details, opened by clicking the battery module. UPower reports
// the numbers the bar has no room for: energy against design capacity, the
// pack's health, the instantaneous rate and the remaining time.
import Quickshell
import Quickshell.Services.UPower
import QtQuick

InfoPopup {
    id: popup

    readonly property var device: UPower.displayDevice
    readonly property bool ready: device ? device.ready : false

    // healthPercentage is only populated on the physical pack, not on UPower's
    // aggregate display device, so the health row reads it from the battery
    // itself. Everything else comes from the aggregate, which is the same
    // device the bar module reads, so the two always agree.
    readonly property var pack: {
        var devices = UPower.devices.values;
        for (var i = 0; i < devices.length; i++) {
            if (devices[i].isLaptopBattery) return devices[i];
        }
        return null;
    }

    readonly property bool healthKnown: pack !== null && pack.healthSupported

    title: "Battery"

    rows: [
        { label: "Source", value: UPower.onBattery ? "Battery" : "AC power" },
        { label: "State", value: popup.stateLabel() },
        { label: "Charge", value: popup.ready
                                  ? Math.round(popup.device.percentage * 100) + "%" : "\u2014" },
        { label: "Energy", value: popup.ready
                                  ? popup.device.energy.toFixed(1) + " / "
                                    + popup.device.energyCapacity.toFixed(1) + " Wh" : "\u2014" },
        { label: "Health", value: popup.healthKnown
                                  ? popup.pack.healthPercentage.toFixed(1) + "%" : "\u2014" },
        { label: "Power", value: popup.ready
                                 ? Math.abs(popup.device.changeRate).toFixed(2) + " W" : "\u2014" },
        { label: "Remaining", value: popup.ready
                                     ? popup.duration(popup.device.state
                                                      === UPowerDeviceState.Charging
                                                      ? popup.device.timeToFull
                                                      : popup.device.timeToEmpty) : "\u2014" }
    ]

    function stateLabel() {
        if (!ready) return "\u2014";
        switch (device.state) {
        case UPowerDeviceState.Charging: return "Charging";
        case UPowerDeviceState.Discharging: return "Discharging";
        case UPowerDeviceState.FullyCharged: return "Full";
        case UPowerDeviceState.PendingCharge: return "Pending charge";
        case UPowerDeviceState.PendingDischarge: return "Pending discharge";
        case UPowerDeviceState.Empty: return "Empty";
        default: return "Unknown";
        }
    }

    // Compact duration: 138d 14h, 3h 20m, 45m.
    function duration(seconds) {
        if (!seconds || seconds <= 0) return "\u2014";
        var minutes = Math.round(seconds / 60);
        var hours = Math.floor(minutes / 60);
        var days = Math.floor(hours / 24);
        if (days > 0) return days + "d " + (hours % 24) + "h";
        if (hours > 0) return hours + "h " + String(minutes % 60).padStart(2, "0") + "m";
        return minutes + "m";
    }
}
