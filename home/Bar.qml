import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.modules.bar

Scope {
	id: root

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: bar

			required property var modelData
			screen: modelData

			exclusiveZone: 26
			height: 26

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

					Rectangle {
						id: workspacesShape
						width: workspaces.implicitWidth + 18
						height: 26
						bottomLeftRadius: 6.5
						bottomRightRadius: 6.5
						color: "#80000000"

						WorkspacesModule { id: workspaces; anchors.centerIn: parent}
					}
				}

				Row {
					id: hRightRow

					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					anchors.rightMargin: 3
					spacing: 3

					Rectangle {
						id: trayShape
						width: tray.implicitWidth + 18
						height: 26
						bottomLeftRadius: 6.5
						bottomRightRadius: 6.5
						color: "#80000000"

						SystemTrayModule { id: tray; anchors.centerIn: parent; parentWindow: bar }
					}

					Rectangle {
						id: radioShape
						width: radioRow.implicitWidth + 18
						height: 26
						bottomLeftRadius: 6.5
						bottomRightRadius: 6.5
						color: "#80000000"

						Row {
							id: radioRow
							anchors.horizontalCenter: parent.horizontalCenter
							spacing: 12

							NetworkModule { }
							// BluetoothModule { }
						}
					}

					Rectangle {
						id: indicatorShape
						width: indicatorRow.implicitWidth + 18
						height: 26
						bottomLeftRadius: 6.5
						bottomRightRadius: 6.5
						color: "#80000000"

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

					Rectangle {
						id: clockShape
						width: clock.implicitWidth + 18
						height: 26
						bottomLeftRadius: 6.5
						bottomRightRadius: 6.5
						color: "#80000000"

						ClockModule { id: clock; anchors.centerIn: parent }
					}
				}
			}
		}
	}
}
