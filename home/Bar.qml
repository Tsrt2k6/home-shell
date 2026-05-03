import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.modules.bar
import qs.services

Scope {
    id: root

    // Create one bar per screen
    Variants {
		model: Theme.ready ? Quickshell.screens : []

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            // Reserve 26px at the top for the bar, but render 76px tall
            // to allow workspace popup to extend below without being clipped
            exclusiveZone: 26
			implicitHeight: modelData.height
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            // Only the visible 26px bar receives mouse input;
            // clicks in the transparent popup area pass through to windows below
            mask: Region {
                item: barContent
            }

            // ── Bar content (top 26px) ─────────────────────────────────────
            Item {
                id: barContent
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 26

                // ── Left side ─────────────────────────────────────────────
                Row {
                    id: hLeftRow
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 3

                    // Workspaces pill
                    Rectangle {
                        id: workspacesShape
                        width: workspaces.implicitWidth + 14
                        height: 26
                        radius: 13
                        color: "#80000000"

                        WorkspacesModule {
                            id: workspaces
                            anchors.centerIn: parent
                        }
                    }
                }

                // ── Right side ────────────────────────────────────────────
                Row {
                    id: hRightRow
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 3
                    spacing: 3

                    // System tray
                    Rectangle {
                        id: trayShape
                        width: tray.implicitWidth + 18
                        height: 26
                        bottomLeftRadius: 6.5
                        bottomRightRadius: 6.5
                        color: "#80000000"

                        SystemTrayModule {
                            id: tray
                            anchors.centerIn: parent
                            parentWindow: bar
                        }
                    }

                    // Network (+ bluetooth when enabled)
                    Rectangle {
                        id: radioShape
                        width: radioRow.implicitWidth + 18
                        height: 26
                        bottomLeftRadius: 6.5
                        bottomRightRadius: 6.5
                        color: "#80000000"

                        Row {
                            id: radioRow
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 12

                            NetworkModule {}
                            // BluetoothModule {}
                        }
                    }

                    // Volume, brightness, battery
                    Rectangle {
                        id: indicatorShape
                        width: indicatorRow.implicitWidth + 18
                        height: 26
                        bottomLeftRadius: 6.5
                        bottomRightRadius: 6.5
                        color: "#80000000"

                        Row {
                            id: indicatorRow
                            anchors.centerIn: parent
                            spacing: 12

                            VolumeIndicatorModule {}
                            BrightnessIndicatorModule {}
                            BatteryIndicatorModule {}
                        }
                    }

                    // Clock
                    Rectangle {
                        id: clockShape
                        width: clock.implicitWidth + 18
                        height: 26
                        bottomLeftRadius: 6.5
                        bottomRightRadius: 6.5
                        color: "#80000000"

                        ClockModule {
                            id: clock
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            // ── End bar content ───────────────────────────────────────────
            // Remaining 50px below barContent is transparent space for
            // the WorkspacesModule popup to render into without clipping
        }
    }
}
