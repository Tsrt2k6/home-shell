pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
	id: root

	required property PopoutState popouts
	readonly property Popout currentPopout: content.children.find(c => c.shouldBeActive) ?? null
	readonly property Item current: currentPopout?.item ?? null

	anchors.centerIn: parent

	implicitWidth: (currentPopout?.implicitWidth ?? 0)
	implicitHeight: (currentPopout?.implicitWidth ?? 0)

	Item {
		id: content

		anchors.fill: parent

		Popout {
			name: "lockstatus"
			sourceComponent: LockStatus { }
		}
	}

	component Popout: Loader {
		id: popout

		required property string name
		readonly property bool shouldBeActive: root.popouts.currentName === name

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right

		opacity: 0
		scale: 0.8
		active: false

		states: State {
			name: "active"
			when: popout.shouldBeActive

			PropertyChanges {
				popout.active: true
				popout.opacity: 1
				popout.scale: 1
			}
		}
	}
}
