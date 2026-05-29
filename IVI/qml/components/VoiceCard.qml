import QtQuick

GlassPanel {

    Rectangle {
        width: 130
        height: 130
        radius: 65

        anchors.centerIn: parent

        color: "#68728b"

        Text {
            anchors.centerIn: parent
            text: "🎤"
            font.pixelSize: 42
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 90

        text: "Listening..."
        color: "white"

        font.pixelSize: 34
        font.weight: Font.Medium
    }
}