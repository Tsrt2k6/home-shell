import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.widgets
import Quickshell.Services.UPower

Item {
    id: root

    // implicitWidth: bgShape.width
    // implicitHeight: bgShape.height
	implicitWidth: batteryRow.implicitWidth
	implicitHeight: 26

    // ── UPower state ──────────────────────────────────────────────────────
    readonly property var battery:      UPower.displayDevice
    readonly property bool isCharging:  battery?.state === UPowerDevice.Charging
    readonly property real percentage:  battery?.percentage ?? 0
    readonly property int batteryLevel: Math.round(percentage * 100)
    readonly property bool isLow:       batteryLevel <= 20 && !isCharging
    readonly property bool isCritical:  batteryLevel <= 10 && !isCharging
    readonly property real watts:       battery?.changeRate ?? 0
    readonly property int emptyTime:    battery?.timeToEmpty ?? 0  // seconds

    // ── Colors ────────────────────────────────────────────────────────────
    readonly property color normalColor: {
        if (isCritical) return "#ef4444"
        if (isLow)      return "#f59e0b"
        return "white"
    }
    readonly property color chargingColor: "#2dd4bf"

    // ── Background ────────────────────────────────────────────────────────
    // BottomRadiusRect {
    //     id: bgShape
    //     width: batteryRow.implicitWidth + 18
    //     height: 26
    // }
    // ── Content row ───────────────────────────────────────────────────────
    Row {
        id: batteryRow
		anchors.centerIn: parent
        spacing: 2

        // Battery icon
        Item {
            width: batteryBody.width + batteryNub.width
            height: 14
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: batteryBody
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 13
                radius: 3
                color: "transparent"
                border.width: 1.5
                border.color: "#80ffffff"

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 2.5
                    width: Math.max(0, (parent.width - 5) * root.percentage)
                    radius: 1.5
                    color: root.isCharging ? "#2dd4bf"
                         : root.isCritical ? "#ef4444"
                         : root.isLow      ? "#f59e0b"
                         : "white"
                    Behavior on color { ColorAnimation { duration: 40 } }
                }
            }

            Rectangle {
                id: batteryNub
                anchors.left: batteryBody.right
                anchors.leftMargin: -1
                anchors.verticalCenter: parent.verticalCenter
                width: 3
                height: 5
                radius: 1.5
                color: "#80ffffff"
            }
        }

        // Percentage text (click to toggle)
        Text {
            id: pctText
            anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -1
            text: root.batteryLevel + "%"
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
            color: "white"
        }

        // Wattage text (click to toggle)
        Text {
            id: wattText
            visible: false
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -1
            text: (root.isCharging ? "+" : "") + root.watts.toFixed(2) + " W"
            font.family: "Quicksand"
            font.pointSize: 12
            font.weight: 600
            color: "white"
        }
    }

    // ── Click to toggle pct / watts ───────────────────────────────────────
    MouseArea {
        anchors.fill: parent
        onClicked: {
            pctText.visible  = !pctText.visible
            wattText.visible = !wattText.visible
        }
    }
}
