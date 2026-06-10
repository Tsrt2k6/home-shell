import QtQuick
import Quickshell
import qs.modules.bar as Bar
import qs.modules.bar.popouts as BarPopouts

Item {
	id: root

	required property ShellScreen screen
	required property Bar.BarWrapper bar

	readonly property alias popouts: popouts

	anchors.fill: parent

	BarPopouts.Wrapper {
		id: popouts

		screen: root.screen

		x: (root.width - nonAnimWidth) / 2
		y: {
			const off = currentCenter - nonAnimHeight / 2;
			const diff = root.height - Math.floor(off + nonAnimHeight);
			if (diff < 0)
				return off + diff;
			return Math.max(off, 0);
		}
	}
}
