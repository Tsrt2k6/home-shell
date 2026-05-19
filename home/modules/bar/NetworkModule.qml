import QtQuick
import Quickshell
import Quickshell.Networking

Item {
    id: root

    implicitWidth: wifiRow.implicitWidth
    implicitHeight: wifiRow.implicitHeight
    // ── Network state ─────────────────────────────────────────────────────
    // Walk devices to find the first connected WifiNetwork
    readonly property var wifiDevice: {
        for (let i = 0; i < Networking.devices.values.length; i++) {
            const dev = Networking.devices.values[i]
            if (dev instanceof WifiDevice && dev.connected) return dev
        }
        return null
    }


	readonly property var wiredDevice: {
        for (let i = 0; i < Networking.devices.values.length; i++) {
            const dev = Networking.devices.values[i]
            // WiredDevice covers Ethernet; exclude WifiDevice to be safe
            if (dev instanceof WiredDevice && dev.connected) return dev
        }
        return null
    }

    readonly property var activeNetwork: {
		if (root.wiredDevice) return null   // ethernet has no "network" object
        if (!root.wifiDevice) return null
        for (let i = 0; i < root.wifiDevice.networks.values.length; i++) {
            const net = root.wifiDevice.networks.values[i]
            if (net.connected) return net
        }
        return null
    }

    readonly property string ssid:     activeNetwork?.name           ?? ""
    readonly property real   strength: activeNetwork?.signalStrength ?? 0.0
    // signalStrength is 0.0–1.0

    // ── Signal icon ───────────────────────────────────────────────────────
    readonly property string icon: {
		if (root.wiredDevice) return "󰈀 "
        if (!root.activeNetwork) return "󰤭 "   // no wifi / disconnected
        if (root.strength >= 0.75) return "󰤨 " // excellent
        if (root.strength >= 0.50) return "󰤥 " // good
        if (root.strength >= 0.25) return "󰤢 " // fair
        return "󰤟 "                             // weak
    }

    // ── Background ────────────────────────────────────────────────────────
    // BottomRadiusRect {
    //     id: bgShape
    //     width: wifiRow.implicitWidth + 18
    //     height: 26
    // }

    // ── Content row ───────────────────────────────────────────────────────
    Row {
        id: wifiRow
        anchors.centerIn: parent
		anchors.verticalCenterOffset: 1
        spacing: 6

        Text {
            id: wifiIcon
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
			color: (root.activeNetwork || root.wiredDevice) ? "white" : "#888888"
            Behavior on color { ColorAnimation { duration: 80 } }
        }

        Text {
            id: ssidText
            anchors.verticalCenter: parent.verticalCenter
            text: root.wiredDevice
                  ? (root.wiredDevice.name ?? "Ethernet")
                  : (root.ssid.length > 0 ? root.ssid : "disconnected")
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
			color: "white"
        }
    }
}
