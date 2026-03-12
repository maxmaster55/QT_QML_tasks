import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: root
    ColumnLayout {
        anchors.fill: parent

        ProgressBar {
            id: busyIndicator
            opacity: 0.9
            Layout.fillWidth: true
            indeterminate: true
            visible: btController.scanning
        }

        ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: btController.devices
            delegate: BtElement {
                rowIndex: index
                name: modelData.name ?? ""
                paired: modelData.paired ?? false
                connected: modelData.connected ?? false
                address: modelData.address ?? ""

                onConnectClicked: addr => btController.connect(addr)
                onPairClicked: addr => btController.pairWithDevice(addr)
                onDisconnectClicked: addr => btController.disconnect(addr)
            }
        }
    }
}
