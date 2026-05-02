import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import qs.modules.widgets

Item {
    id: root

    // implicitWidth: bgShape.implicitWidth
    // implicitHeight: bgShape.implicitHeight
	implicitWidth: brightnessRow.implicitWidth
	implicitHeight: 26

    property real percentage: 0

    Component.onCompleted: {
        readBrightness()
        brightnessWatcher.running = true
    }

    // ── Background ────────────────────────────────────────────────────────
	//    BottomRadiusRect {
	//        id: bgShape
	//        width: brightnessRow.implicitWidth + 18
	//        height: 26
	// }
	// ── Content row ───────────────────────────────────────────────────────
    Row {
        id: brightnessRow
        anchors.centerIn: parent
        spacing: 3

        Text {
            id: brightnessIcon
            text: {
                if (root.percentage >= 75) return "󰃠"
                if (root.percentage >= 50) return "󰃟"
                if (root.percentage >= 25) return "󰃝"
                return "󰃞"
            }
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
            color: "white"
        }

        Text {
            id: brightnessPct
            text: root.percentage + "%"
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
            color: "white"
        }
    }

    // ── Brightness read ───────────────────────────────────────────────────
    function readBrightness() {
        getProcess.command = ["brightnessctl", "-m"]
        getProcess.running = true
    }

    // ── Value fetch process ───────────────────────────────────────────────
    Process {
        id: getProcess
        stdout: SplitParser {
            onRead: data => {
                // brightnessctl -m output: name,type,current,percent%,max
                const parts = data.trim().split(",")
                if (parts.length >= 4) {
                    const value = parseInt(parts[3].replace("%", ""))
                    if (!isNaN(value)) root.percentage = value
                }
            }
        }
    }

    // ── Udev event watcher ────────────────────────────────────────────────
    Process {
        id: brightnessWatcher
        command: ["sh", "-c", "udevadm monitor --udev --subsystem-match=backlight"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("change")) readBrightness()
            }
        }
    }
	// ── Scroll to adjust brightness ───────────────────────────────────────
	property real scrollAccum: 0
    MouseArea {
        anchors.fill: parent
        onWheel: (wheel) => {
			root.scrollAccum += wheel.angleDelta.y
			const threshold = 120 // raise this for less sensitivity (120 = 1 notch, 240 = 2 notches)
			if (Math.abs(root.scrollAccum) >= threshold) {
				root.scrollAccum = 0
				const delta = wheel.angleDelta.y > 0 ? "-": "+"
				setProcess.command = ["swayosd-client", "--brightness", delta + "1", "--min-brightness", "0"]
				setProcess.running = true
			}
        }
    }
    // ── Brightness set process ────────────────────────────────────────────
    Process {
        id: setProcess
    }
}
