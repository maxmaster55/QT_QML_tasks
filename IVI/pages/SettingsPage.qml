import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import IVI

GlassPanel {
    id: settingsScreen
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        Text {
            text: "⚙️ SYSTEM SETTINGS"
            color: "#e2e8f0"
            font.pixelSize: 28
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "Diagnostics, hardware interfaces, and profile parameters."
            color: "#8a94a6"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
