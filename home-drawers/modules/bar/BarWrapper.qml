pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.services

Item {
	id: root
	anchors.top: parent.top
	implicitHeight: 26

	required property ShellScreen screen
	readonly property int exclusiveZone: 26

	Loader {
		id: content

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		active: Theme.ready

		sourceComponent: Bar {
			height: root.height
			screen: root.screen
		}
	}

}
