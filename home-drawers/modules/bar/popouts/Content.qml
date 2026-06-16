pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
	id: root

	required property PopoutState popoutState
	
	readonly property string name: "LockStatus"
	readonly property bool shouldBeActive: popoutState.hasCurrent && popoutState.currentName === name
	
	implicitWidth: loader.item ? loader.item.implicitWidth + 24 : 0
	implicitHeight: loader.item ? loader.item.implicitHeight + 24 : 0

	Loader {
		id: loader

		anchors.centerIn: parent

		opacity: 0
		scale: 0.8

		active: false

		sourceComponent: LockStatus {}

		states: State {
			name: "active"
			when: root.shouldBeActive

			PropertyChanges {
				loader.active: true
				loader.opacity: 1
				loader.scale: 1
			}
		}

		transitions: [
			Transition {
				from: ""
				to: "active"

				SequentialAnimation {
					PropertyAction {
						target: loader
						property: "active"
					}
					NumberAnimation {
						properties: "opacity,scale"
						duration: 200
						easing.type: Easing.OutCubic
					}
				}
			},
			Transition {
				from: "active"
				to: ""

				SequentialAnimation {
					NumberAnimation {
						properties: "opacity,scale"
						duration: 120
						easing.type: Easing.InCubic
					}
					PropertyAction {
						target: loader
						property: "active"
					}
				}
			}
		]
	}
}
// Item {
// 	id: root
//
// 	required property PopoutState popoutState
// 	readonly property Popout currentPopout: content.children.find(c => c.shouldBeActive) ?? null
// 	readonly property Item current: currentPopout?.item ?? null
//
// 	anchors.centerIn: parent
//
// 	implicitWidth: (currentPopout?.implicitWidth ?? 0)
// 	implicitHeight: (currentPopout?.implicitWidth ?? 0)
//
// 	Item {
// 		id: content
//
// 		anchors.fill: parent
//
// 		Popout {
// 			name: "lockstatus"
// 			sourceComponent: LockStatus { }
// 		}
// 	}
//
// 	component Popout: Loader {
// 		id: popout
//
// 		required property string name
// 		readonly property bool shouldBeActive: root.popoutState.currentName === name
//
// 		anchors.verticalCenter: parent.verticalCenter
// 		anchors.right: parent.right
//
// 		opacity: 0
// 		scale: 0.8
// 		active: false
//
// 		states: State {
// 			name: "active"
// 			when: popout.shouldBeActive
//
// 			PropertyChanges {
// 				popout.active: true
// 				popout.opacity: 1
// 				popout.scale: 1
// 			}
// 		}
// 	}
// }
