pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland


Item {
	id: root

	required property ShellScreen screen

    readonly property real nonAnimHeight: y > 0 || hasCurrent ? children.find(c => c.shouldBeActive)?.implicitHeight ?? content.implicitHeight: 0
    readonly property real nonAnimWidth: children.find(c => c.shouldBeActive)?.implicitWidth ?? content.implicitWidth
    readonly property Item current: (content.item as Content)?.current ?? null

    property alias currentName: popoutState.currentName
    property real currentCenter
    property alias hasCurrent: popoutState.hasCurrent
    readonly property PopoutState popState: popoutState


	visible: width > 0 && height > 0

	implicitWidth: nonAnimWidth
	implicitHeight: nonAnimHeight

	function close(): void {
		hasCurrent = false;
	}

	focus: hasCurrent
	Keys.onEscapePressed: {
		close()
	}

	PopoutState {
		id: popoutState
	}

	Comp {
		id: content

		shouldBeActive: root.hasCurrent
		anchors.bottom: parent.bottom
		anchors.verticalCenter: parent.verticalCenter

		sourceComponent: Content {
			popoutState: popoutState
		}
	}

	component Comp: Loader {
		id: comp 

		property bool shouldBeActive

		active: false
		opacity: 0

		states: State {
			name: "active"
			when: comp.shouldBeActive

			PropertyChanges {
				comp.opacity: 1
				comp.active: true
			}
		}

	}
}
