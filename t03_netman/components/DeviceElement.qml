import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property int index
    required property string name
    required property bool is_secured
    required property int strength

    signal connectClicked(string name)

    width: ListView.view.width
    height: 60
    color: index % 2 === 0 ? "#e8f4fd" : "white"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Column {
            Text {
                text: if (root.name === "")
                    "Hidden Network"
                else
                    root.name
                font.pixelSize: 16
            }
            Text {
                text: `Security: ${root.is_secured ? " Locked" : "Open"}`
                font.pixelSize: 12
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: root.strength + "%"
            Layout.alignment: Qt.AlignVCenter
        }

        Button {
            text: "Connect"
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                root.connectClicked(root.name);
            }
        }
    }
}
