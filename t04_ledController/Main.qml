import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import t04_ledController

ApplicationWindow {
    width: 400
    height: 500
    visible: true
    title: "LED Controller"

    Material.theme: Material.Dark
    Material.accent: Material.Orange

    PinController {
        id: pinController
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80
            height: 80
            radius: 40
            color: pinController.pinState ? Material.color(Material.Orange) : "#333"
            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: pinController.pinState ? "LED is ON" : "LED is OFF"
            font.pixelSize: 20
        }

        Button {    
            Layout.alignment: Qt.AlignHCenter
            text: pinController.pinState ? "Turn Off" : "Turn On"
            highlighted: true
            onClicked: pinController.pinState = !pinController.pinState
        }
    }
}
