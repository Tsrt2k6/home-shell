// In a singleton, e.g. services/AppInfo.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var iconMap: ({})

    Process {
        id: desktopReader
        command: ["bash", "-c", "grep -rl '' /usr/share/applications ~/.local/share/applications 2>/dev/null | xargs grep -l 'Icon=' | xargs awk -F= '/^\\[Desktop Entry\\]/,/^\\[/ { if($1==\"Name\" && !name) name=$2; if($1==\"Icon\" && !icon) icon=$2; if($1==\"Exec\" && !exec) exec=$2 } END { if(icon) print name\"|\"icon\"|\"exec }' 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.split("|")
                if (parts.length >= 2) {
                    let name = parts[0].trim().toLowerCase()
                    let icon = parts[1].trim()
                    let exec = (parts[2] ?? "").trim().toLowerCase().split(" ")[0].split("/").pop()
                    // map by name and exec binary name
                    root.iconMap[name] = icon
                    root.iconMap[exec] = icon
                }
            }
        }
    }

    function iconFor(appId) {
        if (!appId) return "application-x-executable"
        let id = appId.toLowerCase()
        let short = id.split(".").pop()
        return iconMap[id] ?? iconMap[short] ?? iconMap[short.split("-")[0]] ?? "application-x-executable"
    }
}
