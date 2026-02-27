import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick


ApplicationWindow {
    width: 800
    height: 600
    visible: true
    Material.theme: Material.Light
    Material.accent: Material.Blue

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "HomePage.qml"
    }

}
