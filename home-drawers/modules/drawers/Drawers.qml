pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.modules.bar

Variants {
	model: Quickshell.screens

	Scope {
		id: scope

		required property ShellScreen modelData

		PanelWindow {
			screen: scope.modelData
			color: 'transparent'
			anchors.top: true
			WlrLayershell.namespace: 'home-border-exclusion'
			exclusiveZone: bar.exclusiveZone
			mask: Region {}
			implicitWidth: 1
			implicitHeight: 1
		}

		PanelWindow {
			id: win
			color: 'transparent'

			screen: scope.modelData
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
			mask: Region { item: bar } 

			anchors.top: true
			anchors.bottom: true
			anchors.left: true
			anchors.right: true

			Interactions {
				screen: scope.modelData
				popouts: panels.popouts
				panels: panels
				bar: bar

				Panels {
					id: panels
					screen: scope.modelData
					bar: bar
				}
				BarWrapper {
					id: bar

					anchors.left: parent.left
					anchors.right: parent.right

					screen: scope.modelData
					popouts: panels.popouts
				}
			}
		}
	}
}
