import QtQuick
import Quickshell
import qs.modules.widgets
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

	Text {
		id: textItem
		anchors.centerIn: parent
		anchors.verticalCenterOffset: -1
		color: "white"
		font.family: "Quicksand"
		font.pointSize: 12
		font.weight: 600

		text: Time.format("hh : mm  AP")
	}
}

