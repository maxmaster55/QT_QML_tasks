import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import IVI

GlassPanel {
    id: hvacScreen
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        Text {
            text: "🌡️ CLIMATE ENVIRONMENT"
            color: "#00f2fe"
            font.pixelSize: 28
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "Multi-zone synchronization controls placeholder."
            color: "#8a94a6"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
