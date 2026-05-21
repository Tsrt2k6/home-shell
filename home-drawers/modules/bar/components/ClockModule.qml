import QtQuick
import Quickshell
import qs.services

Item {
    id: clockContainer

    // implicitWidth: bgShape.width
    // implicitHeight: bgShape.height
	implicitWidth: textItem.implicitWidth
	implicitHeight: textItem.implicitHeight
	
	// BottomRadiusRect {
	// 	id: bgShape
	// 	width: textItem.implicitWidth + 18
	// 	height: 26
	// }
	property bool timeDate: true

	Text {
		id: textItem
		anchors.centerIn: parent
		anchors.verticalCenterOffset: -1
		color: "white"
		font.family: "Quicksand"
		font.pointSize: 12
		font.weight: 600

		text: timeDate ? Time.format("hh : mm  AP") : Time.format("d MMM yyyy")
	}
	MouseArea {
		anchors.fill: textItem
		onClicked: timeDate = !timeDate
	}
}

