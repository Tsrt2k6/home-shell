import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Quickshell
import Quickshell.Io
import qs.modules.widgets

// Interactions:
//   - Scroll up / down  → raise / lower volume by 5 %
//   - Left click        → toggle mute

Item {
    id: root

	// implicitWidth: bgShape.width
	//    implicitHeight: bgShape.height
	implicitWidth: volumeRow.implicitWidth
	implicitHeight: 26

    // ── Bind the default sink so PwNodeAudio properties become valid ──────
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [ Pipewire.defaultAudioSink ] : []
    }

    // Convenience aliases
    readonly property var sink:   Pipewire.defaultAudioSink
    readonly property var audio:  sink ? sink.audio : null
    readonly property bool muted: audio ? audio.muted  : false
    readonly property real vol:   audio ? audio.volume : 0.0   // 0.0 – 1.0

    // Volume icon: pick one of four tiers, or a muted icon
    readonly property string icon: {
        if (!audio || muted) return "audio-volume-muted"
        if (vol <= 0.0)      return "audio-volume-muted"
        if (vol <= 0.33)     return "audio-volume-low"
        if (vol <= 0.66)     return "audio-volume-medium"
        return                      "audio-volume-high"
    }

    // ── Background ────────────────────────────────────────────────────────

    // BottomRadiusRect {
    //     id: bgShape
    //     width: volumeRow.implicitWidth + 18
    //     height: 26
    // }

    // ── Content row ───────────────────────────────────────────────────────
    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: 2

        Text {
            id: iconLabel
            text: {
                if (!root.audio || root.muted) return "󰖁 "   // nerd-font muted
                if (root.vol <= 0.0)           return "󰖁 "
                if (root.vol <= 0.33)          return "󰕿 "   // low
                if (root.vol <= 0.66)          return "󰖀 "   // medium
                return                                "󰕾 "   // high
            }
			font.family: "Quicksand"
            font.pointSize: 12
			font.weight: 600
            color: root.muted ? "#ff8282" : "white"
            Behavior on color { ColorAnimation { duration: 40 } }
        }

        Text {
            id: volLabel
            text: root.audio ? Math.round(root.vol * 100) + "%" : "--"
			font.family: "Quicksand"
            font.pointSize: 12
			font.weight: 600
            color: "white"
            Behavior on color { ColorAnimation { duration: 40 } }
        }
    }

    // ── Mouse / scroll handling ───────────────────────────────────────────
	property real scrollAccum: 0
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        // Toggle mute on click
        onClicked: {
            // if (root.audio) root.audio.muted = !root.audio.muted
			setProcess.command = ["swayosd-client", "--output-volume", "mute-toggle"]
			setProcess.running = true
        }

        // Scroll to adjust volume ±5 %
        //onWheel: (wheel) => {
        //    if (!root.audio) return
        //    const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
        //    root.audio.volume = Math.max(0.0, Math.min(1.5, root.audio.volume + delta))
        //}
		onWheel: (wheel) => {
			root.scrollAccum += wheel.angleDelta.y
			const threshold = 120
			if (Math.abs(root.scrollAccum) >= threshold) {
				const delta = wheel.angleDelta.y > 0 ? "-": "+"
				setProcess.command = ["swayosd-client", "--output-volume", delta + "5", "--max-volume", "150"]
				setProcess.running = true
				root.scrollAccum = 0
			}
		}
    }
	Process {
		id: setProcess
	}
}

