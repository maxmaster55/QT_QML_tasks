import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import t03_netman

Rectangle {
    id: root
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
            model: wifiController.networks
            delegate: DeviceElement {}
        }
    }
}
