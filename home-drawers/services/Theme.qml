pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var colors: ({})
	property string themePath: Quickshell.env("HOME") + "/.local/share/color-schemes/matugen.colors"
	property bool ready: false

    FileView {
        id: fileView
        path: root.themePath
        watchChanges: true
        onFileChanged: reload()
		onTextChanged: {
			root.parseContent(text())
			root.ready = true
		}
    }

    function parseContent(content) {
        if (!content || content.length === 0) return;
        content = content.replace(/^\uFEFF/, '');
        let lines = content.split(/\r?\n/);
        let currentSection = "";
        let newColors = {};
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line.startsWith("[") && line.endsWith("]")) {
                currentSection = line.substring(1, line.length - 1);
            } else if (line.includes("=") && currentSection) {
                let parts = line.split("=");
                if (parts.length >= 2) {
                    let key = parts[0].trim();
                    let value = parts.slice(1).join("=").trim();
                    if (!newColors[currentSection]) newColors[currentSection] = {};
                    newColors[currentSection][key] = value;
                }
            }
        }
        colors = newColors;
    }

    readonly property color windowBg: colors["Colors:Window"]?.BackgroundNormal ?? "#17130b"
    readonly property color highlight: colors["Colors:Selection"]?.BackgroundNormal ?? "#ecc06c"
    readonly property color text: colors["Colors:Window"]?.ForegroundNormal ?? "red"
}
