import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes


Rectangle {
	color: "#80000000"
	bottomLeftRadius: 6.5
	bottomRightRadius: 6.5
}
// Shape {
// 	id: bgShape
// 	antialiasing: true
//
// 	// int width:
// 	// int height:
// 	// real radius: 6.5
// 	// string bgColor: "#80000000"
//
// 	property real radius: 6.5
// 	property string bgColor: "#80000000"
//
// 	ShapePath {
//
// 		strokeWidth: 0
// 		fillColor: bgColor // 50% transparent black
//
// 		// Start at top-left
// 		startX: 0; startY: 0
// 				// top-right corner
// 		PathLine { x: bgShape.width; y: 0 }
//
// 		// right side down to bottom curve start
// 		PathLine { x: bgShape.width; y: bgShape.height - radius }
//
// 		// bottom-right curve
// 		PathQuad { x: bgShape.width - radius; y: bgShape.height; controlX: bgShape.width; controlY: bgShape.height }
//
// 		// bottom edge to bottom-left curve start
// 		PathLine { x: radius; y: bgShape.height }
//
// 		// bottom-left curve
// 		PathQuad { x: 0; y: bgShape.height - radius; controlX: 0; controlY: bgShape.height }
//
// 		// left side up to top-left corner
// 		PathLine { x: 0; y: 0 }
// 	}
// }
