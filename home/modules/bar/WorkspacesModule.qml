import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

Item {
	id: root
	implicitWidth: workspaceRow.implicitWidth
	implicitHeight: 22

	property int numWorkspaces: Math.max(8, Hyprland.workspaceIds.filter((id) => (id > 0)).length)
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
		anchors.fill: parent

		Repeater {
			model: occupiedRanges

			Rectangle {
				anchors.verticalCenter: parent.verticalCenter
				height: parent.height - 6
				radius: height / 2
				color: Theme.colors["Colors:Complementary"].ForegroundLink
				opacity: 0.5
				x: modelData.start * (dotSize + workspaceRow.spacing) - (height - dotSize) / 2
				width: (modelData.end - modelData.start + 1) * dotSize + (modelData.end - modelData.start) * workspaceRow.spacing + (height - dotSize)
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
				id: dotItem
				implicitWidth: dotSize
				implicitHeight: dotSize

				property int wsIndex: index + 1
				property bool occupied: Hyprland.isWorkspaceOccupied(wsIndex)
				property bool focused: wsIndex === Hyprland.focusedWorkspaceId

				Rectangle {
					id: dot
					anchors.centerIn: parent
					// anchors.fill: parent
					implicitHeight: 4
					implicitWidth: 4
					radius: implicitHeight / 2
					color: Theme.colors["Colors:Complementary"].ForegroundNormal
				}
				
				Rectangle {
					id: dotFocused
					anchors.centerIn: parent
					visible: focused
					implicitHeight: dotSize - 2
					implicitWidth: dotSize - 2
					radius: implicitHeight / 2
					color: Theme.colors["Colors:Complementary"].ForegroundNormal
					// color: Theme.colors["Colors:Window"].BackgroundAlternate
				}

                // Find the matching HyprlandWorkspace object
                property var wsObject: {
                    let ws = Hyprland.workspaces.values.find(w => w.id === wsIndex)
                    return ws ?? null
                }

                // Hover popup showing window icons
                Item {
                    id: popup
                    visible: mouseArea.containsMouse && dotItem.wsObject !== null && dotItem.wsObject.toplevels.values.length > 0

                    // Position below the dot, centered
                    x: (dotItem.implicitWidth - popupBox.implicitWidth) / 2
                    y: dotItem.implicitHeight + 8
                    z: 100

                    Rectangle {
                        id: popupBox
                        implicitWidth: iconRow.implicitWidth + 12
                        implicitHeight: iconRow.implicitHeight + 12
                        radius: 8
                        color: "#80000000"
						border.color: Theme.colors["Colors:Complementary"].ForegroundNormal
						border.width: 0.5

                        Column {
                            id: iconRow
                            anchors.centerIn: parent
                            spacing: 6

                            Repeater {
                                model: dotItem.wsObject ? dotItem.wsObject.toplevels.values : []
                                Image {
                                    property var toplevel: modelData
                                    source: Quickshell.iconPath(toplevel.wayland?.appId ?? "", "application-x-executable")
                                    width: 28
                                    height: 28
                                    smooth: true
                                }
                            }
                        }
                    }

                    // Animate in/out
                    opacity: 0
                    scale: 0.85
                    transformOrigin: Item.Top

                    states: State {
                        name: "visible"
                        when: popup.visible
                        PropertyChanges { target: popup; opacity: 1; scale: 1 }
                    }

                    transitions: Transition {
                        NumberAnimation { properties: "opacity,scale"; duration: 100; easing.type: Easing.OutCubic }
                    }
                }



				MouseArea {
					id: mouseArea
					anchors.centerIn: parent
					hoverEnabled: true
					implicitHeight: dotSize + workspaceRow.spacing
					implicitWidth: dotSize + workspaceRow.spacing
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
