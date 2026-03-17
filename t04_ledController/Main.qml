import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    width: 400
    height: 500
    visible: true
    title: "LED Controller"

    Material.theme: Material.Dark
    Material.accent: Material.Orange

    property bool ledOn: false

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80
            height: 80
            radius: 40
            color: ledOn ? Material.color(Material.Orange) : "#333"
            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: ledOn ? "LED is ON" : "LED is OFF"
            font.pixelSize: 20
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: ledOn ? "Turn Off" : "Turn On"
            highlighted: true
            onClicked: ledOn = !ledOn
        }
    }
}
