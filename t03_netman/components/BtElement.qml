import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // ✅ No "required" — delegate context variables can now bind freely
    property int rowIndex: 0
    property string name: ""
    property bool paired: false
    property bool connected: false
    property string address: ""

    signal connectClicked(string address)
    signal disconnectClicked(string address)
    signal pairClicked(string address)

    width: ListView.view.width
    height: 60
    color: rowIndex % 2 === 0 ? "#e8f4fd" : "white"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            text: "⬡"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
        }

        Column {
            Layout.fillWidth: true
            Text {
                text: root.name === "" ? "Unknown Device" : root.name
                font.pixelSize: 16
            }
            Text {
                text: root.connected ? "Connected" : root.paired ? "Paired" : "Not Paired"
                font.pixelSize: 12
                color: root.connected ? "#2e7d32" : root.paired ? "#1565c0" : "#888"
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: root.address
            font.pixelSize: 11
            color: "#aaa"
            Layout.alignment: Qt.AlignVCenter
        }

        Button {
            text: root.connected ? "Disconnect" : root.paired ? "Connect" : "Pair"
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                if (root.connected)
                    root.disconnectClicked(root.address);
                else if (root.paired)
                    root.connectClicked(root.address);
                else
                    root.pairClicked(root.address);
            }
        }
    }
}
