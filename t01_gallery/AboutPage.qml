import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Backend


Item {


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
            text: "About Page"
            font.pixelSize: 24
        }

        LineText {
            item: "Author"
            value: "Youssef"
        }

        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Back"
            Material.background: Material.Blue
            Material.foreground: "white"

            onClicked: {
                stackView.pop()
            }
        }

    }
}
