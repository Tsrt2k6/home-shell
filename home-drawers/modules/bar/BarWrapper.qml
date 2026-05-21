pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Item {
	id: root
	anchors.bottom: parent.bottom
	implicitHeight: 26
	clip: true

	required property ShellScreen screen
	
	readonly property int exclusiveZone: 26

	Rectangle {
		anchors.fill: parent
		color: '#80FFFFFF'
	}
}
