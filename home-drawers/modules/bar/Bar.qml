import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.modules.bar.components
import qs.services

// Scope {
//     id: root
//
//     // Create one bar per screen
//     Variants {
// 		model: Theme.ready ? Quickshell.screens : []
//
//         PanelWindow {
//             id: bar
//             required property var modelData
//             screen: modelData
//
//             // Reserve 26px at the top for the bar, but render 76px tall
//             // to allow workspace popup to extend below without being clipped
//             exclusiveZone: 26
// 			implicitHeight: modelData.height
//             color: "transparent"
//
//             anchors {
//                 top: true
//                 left: true
//                 right: true
//             }
//
//             // Only the visible 26px bar receives mouse input;
//             // clicks in the transparent popup area pass through to windows below
//             // mask: Region {
//             //     item: barContent
//             // }
// 			mask: Region {
// 				// 1. The static bar (always clickable)
// 				Region { item: barContent }
//
// 				// 2. The currently active popup (will be null if none are hovered)
// 				Region { item: workspaces.activePopupItem }
// 			}
// 			// ── Bar content (top 26px) ─────────────────────────────────────
//             // ── End bar content ───────────────────────────────────────────
//             // Remaining 50px below barContent is transparent space for
//             // the WorkspacesModule popup to render into without clipping
//         }
//     }
// }

Item {
	id: barContent

	required property ShellScreen screen

	component BgShape: Rectangle {
		property int padding: 9
		bottomLeftRadius: 6.5
		bottomRightRadius: 6.5
		color: "#80000000"
	}

	// ── Left side ─────────────────────────────────────────────
	Row {
		id: hLeftRow
		anchors.left: parent.left
		anchors.top: parent.top
		height: 22
		spacing: 8

		// Vanity Logo
		Rectangle {
			id: logo
			height: parent.height
			width: parent.height
			topRightRadius: height / 2
			bottomRightRadius: height / 2
			color: Theme.colors["Colors:Complementary"].ForegroundNormal
			Text {
				anchors.centerIn: parent
				text: "󰣇"; font.pointSize: 12
				color: Theme.colors["Colors:Window"].BackgroundAlternate
			}
		}
		// Workspaces pill
		Rectangle {
			id: workspacesShape
			width: workspaces.implicitWidth + 10
			height: parent.height
			radius: height / 2
			color: "#80000000"

			WorkspacesModule {
				id: workspaces
				anchors.centerIn: parent
			}
		}
	}

	// ── Right side ────────────────────────────────────────────
	Row {
		id: hRightRow
		anchors.right: parent.right
		anchors.top: parent.top
		height: parent.height
		anchors.rightMargin: 3
		spacing: 3

		// System tray
		BgShape {
			id: trayShape

			width: tray.implicitWidth + this.padding * 2
			height: parent.height

			SystemTrayModule {
				id: tray
				anchors.centerIn: parent
			}
		}

		// Network (+ bluetooth when enabled)
		BgShape {
			id: radioShape
			
			width: radioRow.implicitWidth + this.padding * 2
			height: parent.height

			Row {
				id: radioRow
				anchors.horizontalCenter: parent.horizontalCenter
				spacing: 12

				NetworkModule {}
				// BluetoothModule {}
			}
		}

		// Volume, brightness, battery
		BgShape {
			id: indicatorShape
			width: indicatorRow.implicitWidth + this.padding * 2
			height: parent.height

			Row {
				id: indicatorRow
				anchors.centerIn: parent
				spacing: 12

				VolumeIndicatorModule {}
				BrightnessIndicatorModule {}
				BatteryIndicatorModule {}
			}
		}

		// Clock
		BgShape {
			id: clockShape
			width: clock.implicitWidth + this.padding * 2
			height: parent.height

			ClockModule {
				id: clock
				anchors.centerIn: parent
			}
		}
	}
}
