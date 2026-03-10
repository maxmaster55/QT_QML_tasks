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
            model: [
                {
                    name: "test",
                    is_secured: false,
                    strength: 50
                }
            ]
            delegate: DeviceElement {}
        }
    }
}
