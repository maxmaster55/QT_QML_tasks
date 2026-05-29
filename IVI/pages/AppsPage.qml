import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import IVI

GlassPanel {
    id: appsScreen
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        Text {
            text: "📱 CORE APPLICATIONS"
            color: "#a855f7"
            font.pixelSize: 28
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "System application package array layout."
            color: "#8a94a6"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
