pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.services
import qs.modules.bar.popouts as BarPopouts

Item {
	id: root
	anchors.top: parent.top

	required property ShellScreen screen
	required property BarPopouts.Wrapper popouts

	readonly property int exclusiveZone: 26

	function closeTray(): void {
		(content.item as Bar)?.closeTray();
	}

	function checkPopout(y: real): void {
		(content.item as Bar)?.checkPopout(y);
	}

	implicitHeight: 26

	Loader {
		id: content

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		active: Theme.ready

		sourceComponent: Bar {
			height: root.height
			screen: root.screen
			popouts: root.popouts
		}
	}

}
