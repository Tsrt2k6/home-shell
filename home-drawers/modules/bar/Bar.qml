import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.modules.bar.popouts as BarPopouts
import qs.modules.bar.components
import qs.services

Item {
	id: barContent

	required property ShellScreen screen
	required property BarPopouts.Wrapper popouts

	// function closeTray(): void {
	// 	for (let i = 0; i < repeater.count; i++) {
	// 		const loader = repeater.itemAt(i) as WrappedLoader;
	// 		if (loader?.enabled && loader.id === "tray") {
	// 			(loader.item as Tray).expanded = false;
	// 		}
	// 	}
	// }

	function checkPopout(x: real): void {
		const ch = childAt(height / 2, x);

		if (ch?.id !== "tray")
			closeTray();

		if (!ch) {
			popouts.hasCurrent = false;
			return;
		}

		const id = ch.id;
		const left = ch.x;
	}

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
