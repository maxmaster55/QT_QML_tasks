import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import IVI


GlassPanel {
    id: fullMusicScreen
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        Text {
            text: "🎵 MUSIC LAYER"
            color: "#4f8cff"
            font.pixelSize: 28
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "Full screen media workspace placeholder."
            color: "#8a94a6"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
