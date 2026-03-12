import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // removed "required" so delegate context vars can bind
    property int index: 0
    property string name: ""
    property bool is_secured: false
    property int strength: 0

    signal connectClicked(string name)

    width: ListView.view.width
    height: 60
    color: index % 2 === 0 ? "#e8f4fd" : "white"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Column {
            Layout.fillWidth: true

            Text {
                text: root.name === "" ? "Hidden Network" : root.name
                font.pixelSize: 16
            }
            Text {
                text: `Security: ${root.is_secured ? "🔒 Locked" : "Open"}`
                font.pixelSize: 12
                color: root.is_secured ? "#888" : "#2e7d32"
            }
        }

        Text {
            text: root.strength + "%"
            Layout.alignment: Qt.AlignVCenter
        }

        Button {
            text: "Connect"
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.connectClicked(root.name)
        }
    }
}
