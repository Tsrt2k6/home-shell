import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.modules.bar
import qs.modules.widgets

Scope {
	id: root

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: bar

			required property var modelData
			screen: modelData

			exclusiveZone: 26
			implicitHeight: 26

			color: 'transparent'

			anchors {
				top: true
				left: true
				right: true
			}

			
			Item {
				anchors.fill: parent

				Row {
					id: hLeftRow

					anchors.horizontalCenter: parent.horizontalCenter
					anchors.leftMargin: 3

					BottomRadiusRect {
						id: workspacesShape
						width: workspaces.implicitWidth + 18
						height: 26

						WorkspacesModule { id: workspaces }
					}
				}

				Row {
					id: hRightRow

					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					anchors.rightMargin: 3
					spacing: 3

					BottomRadiusRect {
						id: trayShape
						width: tray.implicitWidth + 18
						height: 26

						SystemTrayModule { id: tray; anchors.centerIn: parent; parentWindow: bar }
					}

					BottomRadiusRect {
						id: radioShape
						width: radioRow.implicitWidth + 18
						height: 26

						Row {
							id: radioRow
							anchors.horizontalCenter: parent.horizontalCenter
							spacing: 12

							NetworkModule { }
							// BluetoothModule { }
						}
					}

					BottomRadiusRect {
						id: indicatorShape
						// width: volume.implicitWidth + brightness.implicitWidth + battery.implicitWidth
						width: indicatorRow.implicitWidth + 18
						height: 26

						Row {
							id: indicatorRow
							anchors.centerIn: parent
							anchors.horizontalCenter: parent.horizontalCenter
							spacing: 12

							VolumeIndicatorModule { }
							BrightnessIndicatorModule { }
							BatteryIndicatorModule { }

						}
					}

					BottomRadiusRect {
						id: clockShape
						width: clock.implicitWidth + 18
						height: 26

						ClockModule { id: clock; anchors.centerIn: parent }
					}

					// StatusIconsModule { }

					// BatteryIndicatorModule { }
				}
			}
		}
	}
}
