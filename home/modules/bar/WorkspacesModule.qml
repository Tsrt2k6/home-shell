import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

Item {
	id: root
	implicitWidth: workspaceRow.implicitWidth
	implicitHeight: 26

	property int numWorkspaces: 8
	property var workspaceOccupied: []
	property var occupiedRanges: []
	
	// Copied function that sets a list of booleans representing occupied workspaces, and groups occupied workspaces together
    function updateWorkspaceOccupied() {
        const offset = 1;
        workspaceOccupied = Array.from({
            "length": numWorkspaces
        }, (_, i) => {
            return Hyprland.isWorkspaceOccupied(i + 1);
        });
        const ranges = [];
        let start = -1;
        for (let i = 0; i < workspaceOccupied.length; i++) {
            if (workspaceOccupied[i]) {
                if (start === -1)
                    start = i;

            } else if (start !== -1) {
                ranges.push({
                    "start": start,
                    "end": i - 1
                });
                start = -1;
            }
        }
        if (start !== -1)
            ranges.push({
            "start": start,
            "end": workspaceOccupied.length - 1
        });

        occupiedRanges = ranges;
    }

	// Updates workspace indicator when Hyprland singleton gives StateChanged signal
	Connections {
		target: Hyprland
		function onStateChanged() {
			updateWorkspaceOccupied();
		}
	}

	property var dotSize: 12
	
	// Occupied workspace highlight underneath the workspace icons, uses the occupiedRanges for the shape widths
	Item {
		id: occupiedStretchLayer

		anchors.centerIn: parent
		width: parent.width
		implicitHeight: parent.height - 6

		Repeater {
			model: occupiedRanges

			Rectangle {
				height: parent.height
				radius: parent.height / 2
				color: "white"
				opacity: 0.4
				x: modelData.start * (dotSize + workspaceRow.spacing) - (parent.height - dotSize) / 2
				width: (modelData.end - modelData.start + 1) * dotSize + (modelData.end - modelData.start) * workspaceRow.spacing + (parent.height - dotSize)
			}
		}
	}

	// Main workspace icon row
	Row {
		id: workspaceRow

		anchors.centerIn: parent
		spacing: 10

		Repeater {
			model: numWorkspaces
			Item {
				implicitWidth: dot.implicitWidth
				implicitHeight: dot.implicitHeight

				property int wsIndex: index + 1
				property bool occupied: Hyprland.isWorkspaceOccupied(wsIndex)
				property bool focused: wsIndex === Hyprland.focusedWorkspaceId

				Rectangle {
					id: dot
					anchors.centerIn: parent
					implicitHeight: dotSize
					implicitWidth: dotSize
					radius: dotSize / 2

					color: focused ? "red" : "pink"
				}
				
				MouseArea {
					anchors.centerIn: parent
					implicitHeight: dot.implicitHeight + 6
					implicitWidth: dot.implicitWidth + 6
					onClicked: Hyprland.changeWorkspace(wsIndex)
				}

				// Text {
				// 	anchors.centerIn: parent
				// 	text: wsIndex
				// }
			}
		}
	}

}
