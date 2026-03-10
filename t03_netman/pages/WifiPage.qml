import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    ColumnLayout {
        anchors.fill: parent

        ProgressBar {
            id: busyIndicator
            Layout.fillWidth: true
            indeterminate: true
            visible: false
        }

        ListView {
            id: networkList

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            delegate: Rectangle {
                required property int index
                required property var modelData

                width: ListView.view.width
                height: 60
                color: index % 2 === 0 ? "#e8f4fd" : "white"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Column {
                        Text {
                            text: if (modelData.ssid === "")
                                "Hidden Network"
                            else
                                modelData.ssid
                            font.pixelSize: 16
                        }
                        Text {
                            text: `Security: ${modelData.secured ? " Locked" : "Open"}`
                            font.pixelSize: 12
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: modelData.strength + "%"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Button {
                        text: "Connect"
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: wifiController.connectToNetwork(modelData.ssid, "")
                    }
                }
            }
        }
    }
}
