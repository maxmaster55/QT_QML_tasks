import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Backend


Item {
    property date currentTime: new Date()
    property string currentTemp : SystemInfo.temperature()
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            currentTime = new Date();
            currentTemp = SystemInfo.temperature()
        }
    }

    component LineText: Text {
        property string item: ""
        property string value: ""
        text: `${item} : ${value}`
        font.pixelSize: 20

    }

    Column {
        spacing: 10
        padding: 8
        anchors.centerIn: parent


        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Qt Gallery"
            font.pixelSize: 24
        }

        LineText {
            item: "Date"
            value: Qt.formatDate(currentTime, "yyyy/MM/dd")
        }
        LineText {
            item: "Time"
            value: Qt.formatTime(currentTime, "hh:mm ap")
        }

        LineText {
            item: "Temperature"
            value: currentTemp
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Button{
                text: "Open Gallery"
                Material.background: Material.Blue
                Material.foreground: "white"

                onClicked: {
                    stackView.push("SliderPage.qml")
                }
            }

            Button{
                text: "Open About"
                Material.background: Material.Red
                Material.foreground: "white"

                onClicked: {
                    stackView.push("AboutPage.qml")
                }
            }
        }



    }
}
