import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item { // Ensure you have a component type defined (e.g., Item, QtObject)
    id: root
	implicitWidth: trayRow.implicitWidth
	implicitHeight: trayRow.implicitHeight

	Row {
		id: trayRow
		spacing: 5
		anchors.centerIn: parent
		
		Repeater {
			model: SystemTray.items
			delegate: MouseArea {
				id: trayMouseArea
				width: 20
				height: 20
				// modelData is a SystemTrayItem
				IconImage {
					source: modelData.icon
					anchors.fill: parent
					asynchronous: true
					mipmap: true
					smooth: true
				}

				// Handle interactions
				acceptedButtons: Qt.LeftButton | Qt.RightButton
				onClicked: (mouse) => {
					if (mouse.button === Qt.LeftButton) {
						modelData.activate(); // Standard left-click action
					} else if (mouse.button === Qt.RightButton) {
						// Quickshell provides helpers for context menus
						var globalPos = trayMouseArea.mapToGlobal(mouse.x, mouse.y)
						modelData.display(QsWindow.window, globalPos.x, globalPos.y)
					}
				}
			}
		}
	}
}
