import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    Material.accent: Material.Blue

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillWidth: true


            TabEnableButton { label: "Wifi" }
            TabEnableButton { label: "Bluetooth" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // Wifi
            Rectangle {
                color: "lightblue"
                ProgressBar{
                    width: parent.width
                    indeterminate: true
                }
                Text { anchors.centerIn: parent; text: "Wifi Page" }
            }

            // Bt
            Rectangle {
                color: "lightgreen"
                Text { anchors.centerIn: parent; text: "BT page" }
            }
        }
    }

}
