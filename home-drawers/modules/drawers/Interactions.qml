import QtQuick
import QtQuick.Controls
import Quickshell

import qs.modules.bar as Bar
import qs.modules.bar.popouts as BarPopouts


MouseArea {
	id: root
    property int scrollAccumulatedY: 0

    function onWheel(event: WheelEvent): void {
    }

    onWheel: event => {
        // Update accumulated scroll
        if (Math.sign(event.angleDelta.y) !== Math.sign(scrollAccumulatedY))
            scrollAccumulatedY = 0;
        scrollAccumulatedY += event.angleDelta.y;

        // Trigger handler and reset if above threshold
        if (Math.abs(scrollAccumulatedY) >= 120) {
            onWheel(event);
            scrollAccumulatedY = 0;
        }
    }

	required property ShellScreen screen
	required property BarPopouts.Wrapper popouts
	required property Panels panels
	required property Bar.BarWrapper bar

	// function withinPanelHeight(panel: Item, x: real, y: real): bool {
	// 	return y >= panel.y && y <= panel.y + panel.height;
	// }
	//
	// function withinPanelWidth(panel: Item, x: real, y: real): bool {
	// 	return x >= panel.x && x <= panel.x + panel.width;
	// }
	//
	// function inTopPanel(panel: Item, x: real, y: real): bool {
	// 	return y < Math.max(0, panel.height) + panel.y && withinPanelWidth(panel, x, y);
	// }

	anchors.fill: parent
	acceptedButtons: Qt.AllButtons
	hoverEnabled: true

	onContainsMouseChanged: {
		if (!containsMouse) {
			if (!popouts.currentName.startsWith("traymenu") || ((popouts.current as StackView)?.depth ?? 0) <= 1) {
				popouts.hasCurrent = false;
				bar.closeTray();
			}
		}
	}

	onPositionChanged: event => {
		const x = event.x;
		const y = event.y;

		if (y < bar.implicitHeight) {
			bar.checkPopout(x);
			console.log(y, bar.implicitHeight)
		// } else if ((!popouts.currentName.startsWith("traymenu") || ((popouts.current as StackView)?.depth ?? 0) <= 1) && !inTopPanel(panels.popouts, x, y)) {
		} else {
			popouts.hasCurrent = false;
			bar.closeTray();
		}
	}
}
