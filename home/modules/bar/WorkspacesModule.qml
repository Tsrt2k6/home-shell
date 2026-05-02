import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

Item {
	id: root
	implicitWidth: 200
	implicitHeight: 26

	property int numWorkspaces: 8
	property var workspaceOccupied: []
	property var occupiedRanges: []

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

	Component.onCompleted: updateWorkspaceOccupied()
	


	Item {
		id: occupiedStretchLayer

		anchors.verticalCenter: parent.verticalCenter
		anchors.centerIn: parent
		width: parent.implicitWidth
		implicitHeight: 20

		Repeater {
			model: occupiedRanges

			Rectangle {
				height: parent.height
				radius: parent.height / 2
				color: "grey"
				opacity: 0.8
				x: modelData.start * (12 + workspaceRow.spacing) - (parent.height - 12) / 2
				width: (modelData.end - modelData.start + 1) * 12 + (modelData.end - modelData.start) * workspaceRow.spacing + (parent.height - 12)
			}
		}
	}

	Row {
		id: workspaceRow

		anchors.centerIn: bg
		spacing: 10

		Repeater {
			model: numWorkspaces
			Rectangle {
				height: 12
				width: 12
				radius: 12/2
				color: "pink"
			}

			// delegate: Item{
			// 	property int wsIndex: Hyprland.focusedWorkspaceId - 1
			// 	property bool occupied: Hyprland.isWorkspaceOccupied(wsIndex)
			// 	property bool focused: wsIndex === Hyprland.focusedWorkspaceI
			//
			// 	Text {
			// 		anchors.centerIn: parent
			// 		text: "hello"
			// 	}
			// }
			//
		}
	}

}
